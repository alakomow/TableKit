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



	/// Перечисление для задания различных событий генерируемых в процессе работы таблицы.
public enum STKItemAction<CellType: STKCell> {
	public typealias Options = TSKItemActionData<CellType>
	public typealias VoidActionBlock = (Options) -> Void
	public typealias BoolActionBlock = (Options) -> Bool
	public typealias FloatActionBlock = (Options) -> CGFloat
	public typealias IndexPathActionBlock = (Options) -> IndexPath
	public typealias RowActionBlock = (Options) -> [UITableViewRowAction]?
	public typealias AnyActionBlock = (Options) -> Any?
	
	
	// - MARK: Действия для обоих типов таблиц
	/**
		Действие клика по элементу, при задании этого действия будет автоматически вызван deselect для элемента.
		```
		///Действие поддерживается в:
		 1. UITableView
		 2. UICollectionView
		```
	*/
	case click(VoidActionBlock)
	/**
		Действие клика по элементу, отличается от click только отсутствием автоматического вызова deselect.
		Если задано действие click, то select вызываться не будет.
	```
		// Действие поддерживается в:
		1. UITableView
		2. UICollectionView
	```
	*/
	case select(VoidActionBlock)
	/**
		Действие снятия выделения с элемента.
	```
		// Действие поддерживается в:
		1. UITableView
		2. UICollectionView
	```
	*/
	case deselect(VoidActionBlock)
	/**
		Событие отправляемое перед отображением ячейки на экране.
	```
		// Действие поддерживается в:
		1. UITableView
		2. UICollectionView
	```
	*/
	case willDisplay(VoidActionBlock)
	/**
		Событие отправляемое при переходе в нивидимую для пользователя область.
	```
		// Действие поддерживается в:
		1. UITableView
		2. UICollectionView
	```
	*/
	case didEndDisplaying(VoidActionBlock)
	/**
		Событие которое генерируется при заполнении ячейки из вью модели.
	```
		// Действие поддерживается в:
		1. UITableView
		2. UICollectionView
	```
	*/
	case configure(VoidActionBlock)
	
	/**
		Действие определяет возможность перемещения ячейки.
	```
		// Действие поддерживается в:
		1. UITableView
		2. UICollectionView
	```
	*/
	case canMove(BoolActionBlock)
	/**
		Действие вызывается в процессе перемещения ячейки.
	```
		// Действие поддерживается в:
		1. UITableView
		2. UICollectionView
	```
	*/
	case move(VoidActionBlock)
	/**
		Сыбите для обработки дополнительных действий н-р нажатие пользовательской кнопки в ячейке, свайп по ячейке и т.д..
	```
		// Действие поддерживается в:
		1. UITableView
		2. UICollectionView
	```
	*/
	case custom(String, VoidActionBlock)
	
	// - MARK: Действия для только для UITableView
	/**
		Действие удаления элемента
	```
		// Действие поддерживается в:
		1. UITableView
	```
	*/
	case clickDelete(VoidActionBlock)
	/**
		Действие вызывается перед выделением элемента
	```
		// Действие поддерживается в:
		1. UITableView
	```
	*/
	case willSelect(VoidActionBlock)
	
	/**
		Действие вызывается для возможности включения/отлючения выделения ячейки.
	```
		// Действие поддерживается в:
		1. UITableView
	```
	*/
	case shouldHighlight(BoolActionBlock)
	/**
		Действие для задания расчетной высоты ячейки.
	```
		// Действие поддерживается в:
		1. UITableView
	```
	*/
	case estimatedHeight(FloatActionBlock)
	/**
		Действие для задания высоты ячейки.
	```
		// Действие поддерживается в:
		1. UITableView
	```
	*/
	case height(FloatActionBlock)
	/**
		Действие определяет возможность редактирования ячейки.
	```
		// Действие поддерживается в:
		1. UITableView
	```
	*/
	case canEdit(BoolActionBlock)
	/**
		Действие определяет возможность удаления ячейки.
	```
		// Действие поддерживается в:
		1. UITableView
	```
	*/
	case canDelete(BoolActionBlock)
	/**
		Действие вызывается в процессе перемещения ячейки. Определеяет IndexPath назначения.
		Оберка для метода targetIndexPathForMoveFromRowAt sourceIndexPath:h
	```
		// Действие поддерживается в:
		1. UITableView
	```
	*/
	case canMoveTo(IndexPathActionBlock)
	
	/**
		Событие задает UITableViewRowAction для таблицы.
	```
		// Действие поддерживается в:
		1. UITableView
	```
	*/
	case rowActions(RowActionBlock)
	
	var key: STKItemActionType {
		switch self {
		case .click:
			return .click
		case .clickDelete:
			return .clickDelete
		case .select:
			return .select
		case .deselect:
			return .deselect
		case .willSelect:
			return .willSelect
		case .willDisplay:
			return .willDisplay
		case .didEndDisplaying:
			return .didEndDisplaying
		case .shouldHighlight:
			return .shouldHighlight
		case .estimatedHeight:
			return .estimatedHeight
		case .height:
			return .height
		case .canEdit:
			return .canEdit
		case .configure:
			return .configure
		case .canDelete:
			return .canDelete
		case .canMove:
			return .canMove
		case .canMoveTo:
			return .canMoveTo
		case .move:
			return .move
		case .rowActions:
			return .rowActions
		case .custom(let key, _):
			return .custom(key)
		
		}
	}
	
	var handler: AnyActionBlock {
		switch self {
		/// Void - Результат
		case .click(let handler),
			 .clickDelete (let handler),
			 .select(let handler),
			 .deselect(let handler),
			 .willSelect(let handler),
			 .willDisplay(let handler),
			 .didEndDisplaying(let handler),
			 .configure(let handler),
			 .move(let handler):
			return handler
		/// Bool - результат
		case .shouldHighlight(let handler),
			 .canEdit(let handler),
			 .canDelete(let handler),
			 .canMove(let handler):
			return handler
		/// IndexPath action Block
		case .canMoveTo(let handler):
			return handler
		/// CGFloat
		case .estimatedHeight(let handler),
			 .height(let handler):
			return handler
		// UITableViewRowAction
		case .rowActions(let handler):
			return handler
		case .custom(_, let handler):
			return handler
		}
	}
	
	func invoke(options: Options) -> Any? {
		return self.handler(options)
	}
}

/**
	Перечесление для вызова обработчиков событий.
	Полностью дублирует значения из TableRowAction.
*/
public enum STKItemActionType {
	
	case click
	case clickDelete
	case select
	case deselect
	case willSelect
	case willDisplay
	case didEndDisplaying
	case shouldHighlight
	case estimatedHeight
	case height
	case canEdit
	case configure
	case canDelete
	case canMove
	case canMoveTo
	case move
	case rowActions
	case custom(String)
}
extension STKItemActionType: Hashable {}

/**
	Модель данных для отправки в качестве параметра в генерируемых событиях.
	- Parameters:
		- item -
		- cell - ячейка, которая была отображена пользователя, в ряде случаев может быть nil.
*/
public struct TSKItemActionData<CellType: STKCell> {

	/// Oбьект модели данных, из которого формировалась ячейка.
	public let item: CellType.CellData
	/// Ячейка, которая отображена пользователю, в ряде случаев может быть nil.
	public let cell: CellType?
	/// IndexPath текущей ячейки
	public let indexPath: IndexPath
	/// Дополнительная информация, сейчас используется только для передачи дополнительного IndexPath'a при перемещении ячейки.
	public let userInfo: [STKUserInfoKeys: Any]?

	init(item: CellType.CellData, cell: CellType?, path: IndexPath, userInfo: [STKUserInfoKeys: Any]?) {

		self.item = item
		self.cell = cell
		self.indexPath = path
		self.userInfo = userInfo
	}
}
