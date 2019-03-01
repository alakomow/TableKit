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
	func register(nib: UINib, identifier: String, indexPath: IndexPath) -> UIView?
	func register(type: AnyClass, identifier: String, indexPath: IndexPath) -> UIView?
}

class TableCellRegisterer {

    private var registeredIds = Set<String>()
	private var prototypeCells = [String: UIView]()
    private weak var table: TableCellRegistererProtocol?
    
    init(table: TableCellRegistererProtocol?) {
        self.table = table
    }
	
	func register(_ row: Row, indexPath: IndexPath) {
		if registeredIds.contains(row.reuseIdentifier) {
			return
		}
		
		if let nib = row.nib {
			prototypeCells[row.reuseIdentifier] = table?.register(nib: nib, identifier: row.reuseIdentifier, indexPath: indexPath)
		} else {
			prototypeCells[row.reuseIdentifier] = table?.register(type: row.cellType, identifier: row.reuseIdentifier, indexPath: indexPath)
		}
		registeredIds.insert(row.reuseIdentifier)
	}
	
	func prototypeCell<T>(for row: Row, indexPath: IndexPath) -> T? {
		register(row, indexPath: indexPath)
		return prototypeCells[row.reuseIdentifier] as? T
	}
}

extension UITableView: TableCellRegistererProtocol {
	func register(nib: UINib, identifier: String, indexPath: IndexPath) -> UIView? {
		register(nib, forCellReuseIdentifier: identifier)
		return dequeueReusableCell(withIdentifier: identifier)
	}
	
	func register(type: AnyClass, identifier: String, indexPath: IndexPath) -> UIView? {
		guard let cell = self.dequeueReusableCell(withIdentifier: identifier) else {
			register(type, forCellReuseIdentifier: identifier)
			return dequeueReusableCell(withIdentifier: identifier)
		}
		return cell
	}
	
	
}

extension UICollectionView: TableCellRegistererProtocol {
	func register(nib: UINib, identifier: String, indexPath: IndexPath) -> UIView? {
		register(nib, forCellWithReuseIdentifier: identifier)
		return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
	}
	
	func register(type: AnyClass, identifier: String, indexPath: IndexPath) -> UIView? {
		register(type, forCellWithReuseIdentifier: identifier)
		return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
	}
	
	
}
