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
