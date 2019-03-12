

import UIKit

/// Класс используется для автоматической регистрации ячеек.
class TableCellRegisterer {

    private var registeredIds = Set<String>()
	private var prototypeCells = [String: UIView]()
    private weak var table: STKTable?
    
    init(table: STKTable?) {
        self.table = table
    }
	
	func register(_ row: STKItemProtocol?, indexPath: IndexPath) {
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
	
	func prototypeCell<T>(for row: STKItemProtocol?, indexPath: IndexPath) -> T? {
		guard let row = row else { return nil }
		register(row, indexPath: indexPath)
		return prototypeCells[row.cellIdentifier] as? T
	}
}
