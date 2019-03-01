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
	
	var key: String {
		
		switch (self) {
		case .custom(let key):
			return key
		default:
			return "_\(self)"
		}
	}
}

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

private enum TableRowActionHandler<CellType: ConfigurableCell> {

    case voidAction((TableRowActionOptions<CellType>) -> Void)
    case action((TableRowActionOptions<CellType>) -> Any?)

    func invoke(withOptions options: TableRowActionOptions<CellType>) -> Any? {
        
        switch self {
        case .voidAction(let handler):
            return handler(options)
        case .action(let handler):
            return handler(options)
        }
    }
}

open class TableRowAction<CellType: ConfigurableCell> {

    open var id: String?
    public let type: TableRowActionType
    private let handler: TableRowActionHandler<CellType>
    
    public init(_ type: TableRowActionType, handler: @escaping (_ options: TableRowActionOptions<CellType>) -> Void) {

        self.type = type
        self.handler = .voidAction(handler)
    }
    
    public init(_ key: String, handler: @escaping (_ options: TableRowActionOptions<CellType>) -> Void) {
        
        self.type = .custom(key)
        self.handler = .voidAction(handler)
    }
    
    public init<T>(_ type: TableRowActionType, handler: @escaping (_ options: TableRowActionOptions<CellType>) -> T) {

        self.type = type
        self.handler = .action(handler)
    }

    public func invokeActionOn(cell: UIView?, item: CellType.CellData, path: IndexPath, userInfo: [AnyHashable: Any]?) -> Any? {

        return handler.invoke(withOptions: TableRowActionOptions(item: item, cell: cell as? CellType, path: path, userInfo: userInfo))
    }
}
