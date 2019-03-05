

import UIKit

open class TableManager: NSObject {
	public typealias TableType = UITableView
	private(set) weak var tableView: TableType?
	public fileprivate(set) var sections = SafeArray<TableSection>()
	
	private weak var scrollDelegate: UIScrollViewDelegate?
	private(set) var cellRegisterer: TableCellRegisterer?
	
	open var isEmpty: Bool {
		return sections.isEmpty
	}
	
	public init(
		tableView: TableType,
		scrollDelegate: UIScrollViewDelegate? = nil,
		shouldUseAutomaticCellRegistration: Bool = true)
	{
		super.init()
		if shouldUseAutomaticCellRegistration {
			self.cellRegisterer = TableCellRegisterer(table: tableView)
		}
		self.scrollDelegate = scrollDelegate
		self.tableView = tableView
	}
	
	open func reload() {
		tableView?.reloadData()
	}
	
	// MARK: - Private
	private func row(at indexPath: IndexPath) -> Row? {
		if indexPath.section < sections.count && indexPath.row < sections[indexPath.section].rows.count {
			return sections[indexPath.section].rows[indexPath.row]
		}
		return nil
	}
	
	// MARK: Public
	@discardableResult
	open func invoke(
		action: TableRowActionType,
		cell: UITableViewCell?, indexPath: IndexPath,
		userInfo: [AnyHashable: Any]? = nil) -> Any?
	{
		guard let row = row(at: indexPath) else { return nil }
		return row.invoke(
			action: action,
			cell: cell,
			path: indexPath,
			userInfo: userInfo
		)
	}
	
	open override func responds(to selector: Selector) -> Bool {
		return super.responds(to: selector) || scrollDelegate?.responds(to: selector) == true
	}
	
	open override func forwardingTarget(for selector: Selector) -> Any? {
		return scrollDelegate?.responds(to: selector) == true
			? scrollDelegate
			: super.forwardingTarget(for: selector)
	}

	// MARK: - Internal
	func hasAction(_ action: TableRowActionType, atIndexPath indexPath: IndexPath) -> Bool {
		guard let row = row(at: indexPath) else { return false }
		return row.has(action: action)
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
