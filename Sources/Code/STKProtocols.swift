//
//  Protocols.swift
//  TableKit
//
//  Created by Лакомов А.Ю. on 12/03/2019.
//  Copyright © 2019 Tensor. All rights reserved.
//

import UIKit

/**
	Протокол для ячеек таблицы.
	Все используемые в компоненте ячейки должны наследовать этот протокол.
*/
public protocol STKCell: class {
	
	associatedtype CellData: STKViewModel
	
	static var reuseIdentifier: String { get }
	static var nib: UINib? { get }
	
	/// Используется для внутренних событий в ячейке, н-р нажатие кастомной кнопки.
	var customCellActionDelegate: STKCellDelegate? { get set }
	var indexPath: IndexPath? { get set }
	
	func configure(with _: CellData)
	
	func estimatedHeight(with: CellData) -> CGFloat?
	func height(with: CellData) -> CGFloat?
	
}

/**
	Протокол для моделей данных ячеек таблицы.
	Все используемые в компоненте модели данных должны наследовать этот протокол.
*/
public protocol STKViewModel {
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

/// Протокол используется исключительно для передачи кастомных событий в ячейке (например клик по кнопке.)
public protocol STKCellDelegate: class {
	func customAction<CellType: STKCell>(cell: CellType, actionString: String)
}



/// Протокол описывающий неоходимый набор свойств и методов для модели, которая требуется при отображении данных в таблицу.
public protocol STKItemProtocol {
	
	var ID: Int { get }
	var dataHashValue: Int { get }
	var cellIdentifier: String { get }
	var nib: UINib? { get }
	var cellType: AnyClass { get }
	
	
	func configure(_ cell: UIView, indexPath: IndexPath)
	func estimatedHeight(for cell: UIView) -> CGFloat?
	func height(for cell: UIView) -> CGFloat?
	func setupCustomActionDelegate(for cell: UIView?, indexPath: IndexPath)
	
	func copy() -> STKItemProtocol
	func isEditingAllowed(forIndexPath indexPath: IndexPath) -> Bool
	func invoke(
		action: STKItemActionType,
		cell: UIView?,
		path: IndexPath,
		userInfo: [STKUserInfoKeys: Any]?) -> Any?
}
