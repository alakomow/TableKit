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

protocol TableCellRegistererProtocol: class {
	func register(nib: UINib, identifier: String)
	func register(type: AnyClass, identifier: String)
}

class TableCellRegisterer {

    private var registeredIds = Set<String>()
    private weak var table: TableCellRegistererProtocol?
    
    init(table: TableCellRegistererProtocol?) {
        self.table = table
    }
	
	func register(_ row: Row) {
		if registeredIds.contains(row.reuseIdentifier) {
			return
		}
		
		if let nib = row.nib {
			table?.register(nib: nib, identifier: row.reuseIdentifier)
		} else {
			table?.register(type: row.cellType, identifier: row.reuseIdentifier)
		}
		registeredIds.insert(row.reuseIdentifier)
	}
}

extension UITableView: TableCellRegistererProtocol {
	func register(nib: UINib, identifier: String) {
		self.register(nib, forCellReuseIdentifier: identifier)
	}
	
	func register(type: AnyClass, identifier: String) {
		if self.dequeueReusableCell(withIdentifier: identifier) == nil {
			self.register(type, forCellReuseIdentifier: identifier)
		}
	}
	
	
}

extension UICollectionView: TableCellRegistererProtocol {
	func register(nib: UINib, identifier: String) {
		self.register(nib, forCellWithReuseIdentifier: identifier)
	}
	
	func register(type: AnyClass, identifier: String) {
		self.register(type, forCellWithReuseIdentifier: identifier)
	}
	
	
}
