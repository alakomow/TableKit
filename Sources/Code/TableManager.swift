

import UIKit


protocol SheetDataUpdatingProtocol {
	func synchronizeDelegates()
	func reload(sections: SafeArray<SheetSection>, completion: @escaping () -> Void)
	func reload(sections: SafeArray<SheetSection>, animations: TableAnimations, completion: @escaping () -> Void)
}

protocol SheetDelegateAndDataSourceDelegate: class {
	func invoke(action: TableRowActionType, cell: UIView?, indexPath: IndexPath, userInfo: [TableKitUserInfoKeys: Any]?) -> Any?
	func invoke(action: TableRowActionType, cell: UIView?, indexPath: IndexPath) -> Any?
	func register(row: Row?, for indexPath: IndexPath)
	func prototypeCell<T>(for row: Row, indexPath: IndexPath) -> T?
}

protocol SheetDelegateAndDataSource: SheetDataUpdatingProtocol {
	var delegate: SheetDelegateAndDataSourceDelegate { get }
	var displayedSections: SafeArray<SheetSection> { get }
	init?(table: SheetItemsRegistrationsProtocol, delegate: SheetDelegateAndDataSourceDelegate)
	
	func visibleIndexPaths() -> [IndexPath]
}

public class TableManager<TableType> where TableType: SheetItemsRegistrationsProtocol {
	public  let sections = SafeArray<SheetSection>()
	private let cellRegisterer: TableCellRegisterer?
	private let animator = TableAnimator<AnimatebleSection>()
	private unowned let sheet: TableType
	private lazy var dataSourceAndDelegate: SheetDelegateAndDataSource? = {
		return TableViewDataSourceAndDelegate(table: sheet, delegate: self)
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
	
	
	func invoke(action: TableRowActionType, cell: UIView?, indexPath: IndexPath, userInfo: [TableKitUserInfoKeys : Any]?) -> Any? {
		return dataSourceAndDelegate?.displayedSections[safe: indexPath.section]?.rows[safe: indexPath.row]?.invoke(action: action, cell: cell, path: indexPath, userInfo: userInfo)
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
		
		if hasDublicates() {
			dataSourceAndDelegate?.reload(sections: sections, completion: {
				self.dataSourceAndDelegate?.synchronizeDelegates()
			})
			return
		}
		
		let from = dataSourceAndDelegate?.displayedSections.map { AnimatebleSection($0) } ?? []
		let to = sections.map { AnimatebleSection($0) }
		_ = dataSourceAndDelegate
		//TODO: - Обрабатывать ошибку так. Сейчас по факту она не должна возникнуть, потому что выше проверяется.
		var animations = try! animator.buildAnimations(from: from, to: to)
		
		
		let visiblePath = dataSourceAndDelegate?.visibleIndexPaths() ?? []
		let animationPaths = (animations.cells.toDeferredUpdate +
			animations.cells.toDelete +
			animations.cells.toInsert +
			animations.cells.toMove.flatMap { return [$0,$1] } +
			animations.cells.toUpdate)
			
		let pathsForUpdate = visiblePath.filter {
			if animationPaths.contains($0) {
				return false
			}
			if (self.sections.row(for: $0)?.dataHashValue ?? 0) == (dataSourceAndDelegate?.displayedSections.row(for: $0)?.dataHashValue ?? 0) {
				return false
			}
			return true
			
		}
		animations.cells.toDeferredUpdate.append(contentsOf: pathsForUpdate)
		
		dataSourceAndDelegate?.reload(sections: sections, animations: animations, completion: {
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
	
	private func addHandler(section: SheetSection) {
		section.didChangeRowsBlock = { [weak self] in
			self?.synchronizeSections()
		}
	}
}

extension SafeArray where Element: SheetSection {
	fileprivate func row(for path: IndexPath) -> Row? {
		return self[safe: path.section]?.rows[safe: path.row]
	}
}
