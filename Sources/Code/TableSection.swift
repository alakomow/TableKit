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

public class TableSection: NSObject {

	public private(set) var rows: SafeArray<Row>

	public var headerTitle: String?
	public var footerTitle: String?
	public var indexTitle: String?

	public var headerView: UIView?
	public var footerView: UIView?

	public var headerHeight: CGFloat?
	public var footerHeight: CGFloat?

	public var numberOfRows: Int {
		return rows.count
	}

	public var isEmpty: Bool {
		return rows.isEmpty
	}
	
	var didChangeRowsBlock: (() -> Void)?

	public init(rows: [Row] = []) {
		self.rows = SafeArray(rows)
		super.init()
		
		self.rows.elementsDidSetBlock = { [weak self] in
			self?.didChangeRowsBlock?()
		}
	}

	public convenience init(headerTitle: String?, footerTitle: String?, rows: [Row] = []) {
		self.init(rows: rows)
		
		self.headerTitle = headerTitle
		self.footerTitle = footerTitle
	}

	public convenience init(headerView: UIView?, footerView: UIView?, rows: [Row] = []) {
		self.init(rows: rows)
		
		self.headerView = headerView
		self.footerView = footerView
	}
	
	func copy() -> TableSection {
		let copy = TableSection(rows: rows.map { return $0 })
		copy.headerView = headerView
		copy.footerView = footerView
		
		copy.headerTitle = headerTitle
		copy.footerTitle = footerTitle
		copy.indexTitle = indexTitle
		
		copy.headerHeight = headerHeight
		copy.footerHeight = footerHeight
		return copy
	}

	// MARK: - Public -

	public func clear() {
		rows.removeAll()
	}

	public func append(row: Row) {
		append(rows: [row])
	}

	public func append(rows: [Row]) {
		self.rows.appent(elements: rows)
	}

	public func insert(row: Row, at index: Int) {
		rows.insert(row, at: index)
	}

	public func insert(rows: [Row], at index: Int) {
		self.rows.insert(rows, at: index)
	}

	public func replace(rowAt index: Int, with row: Row) {
		self.rows.replace(at: index, with: row)
	}

	public func swap(from: Int, to: Int) {
		rows.swap(from: from, to: to)
	}

	public func remove(rowAt index: Int) {
		rows.remove(elementAt: index)
	}
}
