//
//    Copyright (c) 2015 Max Sokolov https://twitter.com/max_sokolov
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

/**
    Responsible for table view's datasource and delegate.
 */
open class TableDirector: NSObject {
	public typealias TableType = UITableView
    open private(set) weak var tableView: TableType?
    open fileprivate(set) var sections = SafeArray<TableSection>()
    
    private weak var scrollDelegate: UIScrollViewDelegate?
    private(set) var cellRegisterer: TableCellRegisterer?
    public private(set) var rowHeightCalculator: RowHeightCalculator?
    
    open var isEmpty: Bool {
        return sections.isEmpty
    }
    
    public init(
        tableView: TableType,
        scrollDelegate: UIScrollViewDelegate? = nil,
        shouldUseAutomaticCellRegistration: Bool = true,
        cellHeightCalculator: RowHeightCalculator?)
    {
        super.init()
        if shouldUseAutomaticCellRegistration {
			self.cellRegisterer = TableCellRegisterer(table: tableView)
        }
        
        self.rowHeightCalculator = cellHeightCalculator
        self.scrollDelegate = scrollDelegate
        self.tableView = tableView

        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveAction), name: NSNotification.Name(rawValue: TableKitNotifications.CellAction), object: nil)
    }
    
    public convenience init(
        tableView: TableType,
        scrollDelegate: UIScrollViewDelegate? = nil,
        shouldUseAutomaticCellRegistration: Bool = true,
        shouldUsePrototypeCellHeightCalculation: Bool = false)
    {
        let heightCalculator: TablePrototypeCellHeightCalculator? = shouldUsePrototypeCellHeightCalculation
            ? TablePrototypeCellHeightCalculator(tableView: tableView)
            : nil
        
        self.init(
            tableView: tableView,
            scrollDelegate: scrollDelegate,
            shouldUseAutomaticCellRegistration: shouldUseAutomaticCellRegistration,
            cellHeightCalculator: heightCalculator
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
	
    @objc
    func didReceiveAction(_ notification: Notification) {
		
        guard let action = notification.object as? TableCellAction, let indexPath = tableView?.indexPath(for: action.cell) else { return }
        invoke(action: .custom(action.key), cell: action.cell, indexPath: indexPath, userInfo: notification.userInfo)
    }
}

// MARK: - Sections manipulation
extension TableDirector {
	
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
        
        rowHeightCalculator?.invalidate()
        sections.removeAll()
        
        return self
    }
}
