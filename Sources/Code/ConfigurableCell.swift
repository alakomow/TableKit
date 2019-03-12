

import UIKit

/// Протокол используется исключительно для передачи кастомных событий в ячейке (например клик по кнопке.)
public protocol ConfigurableCellDelegate: class {
	func customAction<CellType: ConfigurableCell>(cell: CellType, actionString: String)
}

public protocol ConfigurableViewModel {
	var identifier: Int { get }
	/**
	Hash значение всех пропертей модели, необходимо для обноления данных в случае, если произошли изменения каких-то полей модели.
	```
	// Пример использования:
	var propertiesHashValue: Int {
		return propery1.hashValue ^
			property2.hashValue ^
			....
			propertyN.hashValue
	}
	
	```
	*/
	var propertiesHashValue: Int {  get }
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
