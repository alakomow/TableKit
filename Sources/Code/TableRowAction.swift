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

public enum TableRowAction<CellType: ConfigurableCell> {
	public typealias Options = TableRowActionOptions<CellType>
	public typealias VoidActionBlock = (Options) -> Void
	public typealias BoolActionBlock = (Options) -> Bool
	public typealias FloatActionBlock = (Options) -> CGFloat
	public typealias AnyActionBlock = (Options) -> Any?
	
	case click(VoidActionBlock)
	case clickDelete(VoidActionBlock)
	case select(VoidActionBlock)
	case deselect(VoidActionBlock)
	case willSelect(VoidActionBlock)
	case willDisplay(VoidActionBlock)
	case didEndDisplaying(VoidActionBlock)
	case shouldHighlight(BoolActionBlock)
	case estimatedHeight(FloatActionBlock)
	case height(FloatActionBlock)
	case canEdit(BoolActionBlock)
	case configure(VoidActionBlock)
	case canDelete(BoolActionBlock)
	case canMove(BoolActionBlock)
	case canMoveTo(BoolActionBlock)
	case move(VoidActionBlock)
	case custom(String,AnyActionBlock)
	
	var key: TableRowActionType {
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
		case .custom(let key, _):
			return .custom(key)
		
		}
	}
	
	private var handler: AnyActionBlock {
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
			 .canMove(let handler),
			 .canMoveTo(let handler):
			return handler
		/// CGFloat
		case .estimatedHeight(let handler),
			 .height(let handler):
			return handler
		case .custom(_, let handler):
			return handler
		}
	}
	
	func invoke(options: Options) -> Any? {
		return self.handler(options)
	}
}

public enum TableRowActionType {
	
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
	case custom(String)
}
extension TableRowActionType: Hashable {}

open class TableRowActionOptions<CellType: ConfigurableCell> {

    public let item: CellType.CellData
    public let cell: CellType?
    public let indexPath: IndexPath
    public let userInfo: [AnyHashable: Any]?

    init(item: CellType.CellData, cell: CellType?, path: IndexPath, userInfo: [AnyHashable: Any]?) {

        self.item = item
        self.cell = cell
        self.indexPath = path
        self.userInfo = userInfo
    }
}
