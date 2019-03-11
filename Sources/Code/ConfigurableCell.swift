

import UIKit

/// Протокол используется исключительно для передачи кастомных событий в ячейке (например клик по кнопке.)
public protocol ConfigurableCellDelegate: class {
	func customAction<CellType: ConfigurableCell>(cell: CellType, actionString: String)
}

public protocol ConfigurableViewModel {
	var identifier: Int { get }
	var propertiesHashValue: Int {  get }
}

public protocol ConfigurableCell: class {
	
	associatedtype CellData: ConfigurableViewModel
	
	static var reuseIdentifier: String { get }
	static var nib: UINib? { get }
	
	/// Используется для внутренних событий в ячейке, н-р нажатие кастомной кнопки.
	var customCellActionDelegate: ConfigurableCellDelegate? { get set }
	var indexPath: IndexPath? { get set }
	
	func estimatedHeight(with: CellData) -> CGFloat?
	func height(with: CellData) -> CGFloat?
	func configure(with _: CellData)
}

public extension ConfigurableCell where Self: UIView {
	
	static var reuseIdentifier: String {
		return String(describing: self)
	}
	
	static var nib: UINib? {
		let bundle = Bundle(for: self)
		guard let _ = bundle.path(forResource: reuseIdentifier, ofType: "nib") else { return nil }
		return UINib(nibName: reuseIdentifier, bundle: bundle)
	}
	
	func estimatedHeight(with: CellData) -> CGFloat? { return nil }
	func height(with: CellData) -> CGFloat? { return nil }
}
