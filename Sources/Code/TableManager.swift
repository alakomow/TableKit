

import UIKit


protocol SheetDataUpdatingProtocol {
	func synchronizeDelegates()
	func reload(completion: @escaping () -> Void)
	func reload(with animations: TableAnimations, completion: @escaping () -> Void)
}

protocol SheetDelegateAndDataSourceDelegate: class {
	func sheetSections() -> SafeArray<TableSection>
	func invoke(action: TableRowActionType, cell: UIView?, indexPath: IndexPath, userInfo: [AnyHashable: Any]?) -> Any?
	func invoke(action: TableRowActionType, cell: UIView?, indexPath: IndexPath) -> Any?
	func register(row: Row?, for indexPath: IndexPath)
	func prototypeCell<T>(for row: Row, indexPath: IndexPath) -> T?
}

protocol SheetDelegateAndDataSource: SheetDataUpdatingProtocol {
	var delegate: SheetDelegateAndDataSourceDelegate { get }
	init?(tableView: SheetItemsRegistrationsProtocol, delegate: SheetDelegateAndDataSourceDelegate)
	
	func visibleIndePaths() -> [IndexPath]
}

public class TableManager<TableType> where TableType: SheetItemsRegistrationsProtocol {
	public  let sections = SafeArray<TableSection>()
	private let displayedSections = SafeArray<TableSection>()
	private let cellRegisterer: TableCellRegisterer?
	private unowned let sheet: TableType
	private lazy var dataSourceAndDelegate: SheetDelegateAndDataSource? = {
		return TableViewManager(tableView: sheet, delegate: self)
	}()
	
	public init( sheet: TableType, shouldUseAutomaticCellRegistration: Bool = true) {
		self.sheet = sheet
		self.cellRegisterer = shouldUseAutomaticCellRegistration ? TableCellRegisterer(table: sheet) : nil
		self.sections.elementsDidSetBlock = { [weak self] in
			self?.sections.forEach { self?.addHandler(section: $0) }
			self?.synchronizeSections()
		}
	}
}

extension TableManager: SheetDelegateAndDataSourceDelegate {
	func sheetSections() -> SafeArray<TableSection> {
		return displayedSections
	}
	
	func invoke(action: TableRowActionType, cell: UIView?, indexPath: IndexPath, userInfo: [AnyHashable : Any]?) -> Any? {
		return displayedSections[safe: indexPath.section]?.rows[safe: indexPath.row]?.invoke(action: action, cell: cell, path: indexPath, userInfo: userInfo)
	}
	
	func invoke(action: TableRowActionType, cell: UIView?, indexPath: IndexPath) -> Any? {
		return invoke(action: action, cell: cell, indexPath: indexPath, userInfo: nil)
	}
	
	func register(row: Row?, for indexPath: IndexPath) {
		cellRegisterer?.register(row, indexPath: indexPath)
	}
	
	func prototypeCell<T>(for row: Row, indexPath: IndexPath) -> T? {
		return cellRegisterer?.prototypeCell(for: row, indexPath: indexPath)
	}
}

extension TableManager {
	func synchronizeSections() {
		
		let setDisplayedSectionBlock = {
			self.displayedSections.removeAll()
			self.displayedSections.appent(elements: self.sections.map { return $0.copy() })
		}
		
		if hasDublicates() {
			setDisplayedSectionBlock()
			dataSourceAndDelegate?.reload {
				self.dataSourceAndDelegate?.synchronizeDelegates()
			}
			return
		}
		let animator = TableAnimator<AnimatebleSection>()
		
		let from = displayedSections.map { AnimatebleSection($0) }
		let to = sections.map { AnimatebleSection($0) }
		_ = dataSourceAndDelegate
		//TODO: - Обрабатывать ошибку так. Сейчас по факту она не должна возникнуть, потому что выше проверяется.
		let animations = try! animator.buildAnimations(from: from, to: to)
		
		setDisplayedSectionBlock()
		dataSourceAndDelegate?.reload(with: animations, completion: {
			self.dataSourceAndDelegate?.synchronizeDelegates()
		})
	}
	
	/// Все элементы должны быть уникальны, иначе аниматору будет плохо, и всеравно все упадет
	private func hasDublicates() -> Bool {
		return hasSectionDublicates() || hasElementDublicates()
	}
	
	private func hasSectionDublicates() -> Bool {
		return sections.count != Set(sections.map { return $0 }).count
	}
	
	private func hasElementDublicates() -> Bool {
		let allElements = sections.flatMap { $0.rows.map { $0.ID } }
		return allElements.count != Set(allElements).count
	}
}

// MARK: - Sections manipulation
extension TableManager {
	
	public var isEmpty: Bool {
		return sections.isEmpty
	}
	
	public func append(section: TableSection)  {
		append(sections: [section])
	}

	public func append(sections: [TableSection]) {
		sections.forEach { self.addHandler(section: $0) }
		self.sections.appent(elements: sections)
	}

	public func append(rows: [Row]) {
		let section = TableSection(rows: rows)
		addHandler(section: section)
		append(section: section)
	}

	public func insert(section: TableSection, atIndex index: Int) {
		addHandler(section: section)
		sections.insert(section, at: index)
	}

	public func replaceSection(at index: Int, with section: TableSection) {
		addHandler(section: section)
		sections.replace(at: index, with: section)
	}

	public func delete(sectionAt index: Int) {
		sections.remove(elementAt: index)
	}

	public func remove(sectionAt index: Int) {
		delete(sectionAt: index)
	}

	public func clear() {
		sections.removeAll()
	}
	
	private func addHandler(section: TableSection) {
		section.didChangeRowsBlock = { [weak self] in
			self?.synchronizeSections()
		}
	}
}
