

import UIKit

public protocol SheetItemsRegistrationsProtocol: class {
	func register(nib: UINib, identifier: String, indexPath: IndexPath) -> UIView?
	func register(type: AnyClass, identifier: String, indexPath: IndexPath) -> UIView?
}

/// Класс используется для автоматической регистрации ячеек.
class TableCellRegisterer {

    private var registeredIds = Set<String>()
	private var prototypeCells = [String: UIView]()
    private weak var table: SheetItemsRegistrationsProtocol?
    
    init(table: SheetItemsRegistrationsProtocol?) {
        self.table = table
    }
	
	func register(_ row: SbisItem?, indexPath: IndexPath) {
		guard let row = row else { return }
		if registeredIds.contains(row.cellIdentifier) {
			return
		}
		
		if let nib = row.nib {
			prototypeCells[row.cellIdentifier] = table?.register(nib: nib, identifier: row.cellIdentifier, indexPath: indexPath)
		} else {
			prototypeCells[row.cellIdentifier] = table?.register(type: row.cellType, identifier: row.cellIdentifier, indexPath: indexPath)
		}
		registeredIds.insert(row.cellIdentifier)
	}
	
	func prototypeCell<T>(for row: SbisItem?, indexPath: IndexPath) -> T? {
		guard let row = row else { return nil }
		register(row, indexPath: indexPath)
		return prototypeCells[row.cellIdentifier] as? T
	}
}

extension UITableView: SheetItemsRegistrationsProtocol {
	public func register(nib: UINib, identifier: String, indexPath: IndexPath) -> UIView? {
		register(nib, forCellReuseIdentifier: identifier)
		return dequeueReusableCell(withIdentifier: identifier)
	}
	
	public func register(type: AnyClass, identifier: String, indexPath: IndexPath) -> UIView? {
		guard let cell = self.dequeueReusableCell(withIdentifier: identifier) else {
			register(type, forCellReuseIdentifier: identifier)
			return dequeueReusableCell(withIdentifier: identifier)
		}
		return cell
	}
	
	
}

extension UICollectionView: SheetItemsRegistrationsProtocol {
	public func register(nib: UINib, identifier: String, indexPath: IndexPath) -> UIView? {
		register(nib, forCellWithReuseIdentifier: identifier)
		return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
	}
	
	public func register(type: AnyClass, identifier: String, indexPath: IndexPath) -> UIView? {
		register(type, forCellWithReuseIdentifier: identifier)
		return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
	}
	
	
}
