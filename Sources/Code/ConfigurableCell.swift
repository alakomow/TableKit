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

public protocol ConfigurableCellDelegate: class {
	func customAction<CellType: ConfigurableCell>(cell: CellType, actionString: String)
}

public protocol ConfigurableCell: class {
	
	associatedtype CellData
	
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
