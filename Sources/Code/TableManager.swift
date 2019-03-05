

import UIKit


protocol SheetDataUpdatingProtocol {
	func reloadData()
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
		displayedSections.removeAll()
		displayedSections.appent(elements: sections.map { return $0 })
		dataSourceAndDelegate?.reloadData()
	}
}

// MARK: - Sections manipulation
extension TableManager {
	
	public var isEmpty: Bool {
		return sections.isEmpty
	}
	
	@discardableResult
	public func append(section: TableSection) -> Self {
		
		append(sections: [section])
		return self
	}

	@discardableResult
	public func append(sections: [TableSection]) -> Self {
		
		self.sections.appent(elements: sections)
		return self
	}

	@discardableResult
	public func append(rows: [Row]) -> Self {
		
		append(section: TableSection(rows: rows))
		return self
	}

	@discardableResult
	public func insert(section: TableSection, atIndex index: Int) -> Self {
		
		sections.insert(section, at: index)
		return self
	}

	@discardableResult
	public func replaceSection(at index: Int, with section: TableSection) -> Self {
		sections.replace(at: index, with: section)
		return self
	}

	@discardableResult
	public func delete(sectionAt index: Int) -> Self {
		
		sections.remove(elementAt: index)
		return self
	}

	@discardableResult
	public func remove(sectionAt index: Int) -> Self {
		return delete(sectionAt: index)
	}

	@discardableResult
	public func clear() -> Self {
		sections.removeAll()
		
		return self
	}
	
	public func reload() {
		synchronizeSections()
	}
}
