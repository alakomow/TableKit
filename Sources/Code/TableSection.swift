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

final public class TableSection: SheetSection {
	public var headerTitle: String?
	public var footerTitle: String?
	
	public var headerView: UIView?
	public var footerView: UIView?
	
	public var headerHeight: CGFloat?
	public var footerHeight: CGFloat?
	
	public convenience init(headerTitle: String?, footerTitle: String?, rows: [Row] = [], identifier: Int? = nil) {
		self.init(rows: rows, identifier: identifier)
		
		self.headerTitle = headerTitle
		self.footerTitle = footerTitle
	}
	
	public convenience init(headerView: UIView?, footerView: UIView?, rows: [Row] = [], identifier: Int? = nil) {
		self.init(rows: rows, identifier: identifier)
		
		self.headerView = headerView
		self.footerView = footerView
	}
	
	override func copy() -> TableSection {
		let copy = TableSection(rows: rows.map { $0.copy() }, identifier: identifier)
		copy.headerView = headerView
		copy.footerView = footerView
		
		copy.headerTitle = headerTitle
		copy.footerTitle = footerTitle
		copy.indexTitle = indexTitle
		
		copy.headerHeight = headerHeight
		copy.footerHeight = footerHeight
		return copy
	}
}
