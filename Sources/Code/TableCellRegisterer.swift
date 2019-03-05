

import UIKit

protocol TableCellRegistererProtocol: class {
	func register(nib: UINib, identifier: String, indexPath: IndexPath) -> UIView?
	func register(type: AnyClass, identifier: String, indexPath: IndexPath) -> UIView?
}

/// Класс используется для автоматической регистрации ячеек.
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
