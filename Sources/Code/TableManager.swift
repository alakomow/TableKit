

import UIKit


public protocol SheetDataUpdatingProtocol {
	func reloadData()
}

protocol SheetDataSourceAndDelegate: SheetDataUpdatingProtocol {
	func row(at indexPath: IndexPath) -> Row?
	func section(at section: Int) -> TableSection?
	func invoke(action: TableRowActionType, cell: UIView?, indexPath: IndexPath, userInfo: [AnyHashable: Any]?) -> Any?
	func register(row: Row, for indexPath: IndexPath)
}

open class TableManager<TableType> where TableType: SheetItemsRegistrationsProtocol & SheetDataUpdatingProtocol {
	private weak var tableView: TableType?
	public private(set) var sections = SafeArray<TableSection>()
	private var displayedSections = SafeArray<TableSection>()
	private let cellRegisterer: TableCellRegisterer?
	
	open var isEmpty: Bool {
		return sections.isEmpty
	}
	
	public init(
		tableView: TableType,
		shouldUseAutomaticCellRegistration: Bool = true)
	{
		self.tableView = tableView
		let xc = UITableView(frame: .zero)
		xc.reloadData()
		self.cellRegisterer = shouldUseAutomaticCellRegistration ? TableCellRegisterer(table: tableView) : nil
	}
}

extension TableManager: SheetDataSourceAndDelegate {
	func row(at indexPath: IndexPath) -> Row? {
		return displayedSections[safe: indexPath.section]?.rows[safe: indexPath.row]
	}
	
	func section(at section: Int) -> TableSection? {
		return displayedSections[safe: section]
	}
	
	func invoke(action: TableRowActionType, cell: UIView?, indexPath: IndexPath, userInfo: [AnyHashable : Any]?) -> Any? {
		return row(at: indexPath)?.invoke(action: action, cell: cell, path: indexPath, userInfo: userInfo)
	}
	
	func register(row: Row, for indexPath: IndexPath) {
		cellRegisterer?.register(row, indexPath: indexPath)
	}
	
	public func reloadData() {
		tableView?.reloadData()
	}
	
	
}

// MARK: - Sections manipulation
extension TableManager {
	
	@discardableResult
	open func append(section: TableSection) -> Self {
		
		append(sections: [section])
		return self
	}

	@discardableResult
	open func append(sections: [TableSection]) -> Self {
		
		self.sections.appent(elements: sections)
		return self
	}

	@discardableResult
	open func append(rows: [Row]) -> Self {
		
		append(section: TableSection(rows: rows))
		return self
	}

	@discardableResult
	open func insert(section: TableSection, atIndex index: Int) -> Self {
		
		sections.insert(section, at: index)
		return self
	}

	@discardableResult
	open func replaceSection(at index: Int, with section: TableSection) -> Self {
		sections.replace(at: index, with: section)
		return self
	}

	@discardableResult
	open func delete(sectionAt index: Int) -> Self {
		
		sections.remove(elementAt: index)
		return self
	}

	@discardableResult
	open func remove(sectionAt index: Int) -> Self {
		return delete(sectionAt: index)
	}

	@discardableResult
	open func clear() -> Self {
		sections.removeAll()
		
		return self
	}
}
