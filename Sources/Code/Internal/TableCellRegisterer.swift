

import UIKit

/// Класс используется для автоматической регистрации ячеек.
class TableCellRegisterer {

    private var registeredIds = Set<Int>()
	private var prototypeCells = [Int: UIView]()
    private weak var table: STKTable?
    
    init(table: STKTable?) {
        self.table = table
    }
	
	func register(_ row: STKItemProtocol?, indexPath: IndexPath) {
		guard let row = row else { return }
		if registeredIds.contains(row.cellIdentifier.hashValue ^ indexPath.hashValue) {
			return
		}
		
		if row.needCellRegistration {
			if let nib = row.nib {
				prototypeCells[row.cellIdentifier.hashValue ^ indexPath.hashValue] = table?.register(nib: nib, identifier: row.cellIdentifier, indexPath: indexPath)
			} else {
				prototypeCells[row.cellIdentifier.hashValue ^ indexPath.hashValue] = table?.register(type: row.cellType, identifier: row.cellIdentifier, indexPath: indexPath)
			}
		} else {
			prototypeCells[row.cellIdentifier.hashValue ^ indexPath.hashValue] = table?.cell(for: row.cellIdentifier, indexPath: indexPath)
		}
		registeredIds.insert(row.cellIdentifier.hashValue ^ indexPath.hashValue)
	}
	
	func prototypeCell<T>(for row: STKItemProtocol?, indexPath: IndexPath) -> T? {
		guard let row = row else { return nil }
		register(row, indexPath: indexPath)
		return prototypeCells[row.cellIdentifier.hashValue ^ indexPath.hashValue] as? T
	}
}
