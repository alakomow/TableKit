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

open class TableSection {

	open private(set) var rows: SafeArray<Row>

	open var headerTitle: String?
	open var footerTitle: String?
	open var indexTitle: String?

	open var headerView: UIView?
	open var footerView: UIView?

	open var headerHeight: CGFloat?
	open var footerHeight: CGFloat?

	open var numberOfRows: Int {
		return rows.count
	}

	open var isEmpty: Bool {
		return rows.isEmpty
	}

	public init(rows: [Row] = []) {
		self.rows = SafeArray(rows)
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

	// MARK: - Public -

	open func clear() {
		rows.removeAll()
	}

	open func append(row: Row) {
		append(rows: [row])
	}

	open func append(rows: [Row]) {
		self.rows.appent(elements: rows)
	}

	open func insert(row: Row, at index: Int) {
		rows.insert(row, at: index)
	}

	open func insert(rows: [Row], at index: Int) {
		self.rows.insert(rows, at: index)
	}

	open func replace(rowAt index: Int, with row: Row) {
		self.rows.replace(at: index, with: row)
	}

	open func swap(from: Int, to: Int) {
		rows.swap(from: from, to: to)
	}

	open func remove(rowAt index: Int) {
		rows.remove(elementAt: index)
	}
}
