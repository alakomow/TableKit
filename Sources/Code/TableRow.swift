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

public class TableRow<CellType: ConfigurableCell>: Row where CellType: UITableViewCell {
    
    public let item: CellType.CellData
    private lazy var actions = [String: [TableRowAction<CellType>]]()
    private(set) public var editingActions: [UITableViewRowAction]?
    
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    public var reuseIdentifier: String {
        return CellType.reuseIdentifier
    }
	
	public var nib: UINib? {
		return CellType.nib
	}
    
    public var cellType: AnyClass {
        return CellType.self
    }
    
    public init(item: CellType.CellData, actions: [TableRowAction<CellType>]? = nil, editingActions: [UITableViewRowAction]? = nil) {
        
        self.item = item
        self.editingActions = editingActions
        actions?.forEach { on($0) }
    }
    
    // MARK: - RowConfigurable -
    
    public func configure(_ cell: UITableViewCell) {
        
        (cell as? CellType)?.configure(with: item)
    }
	
	public func height(_ cell: UITableViewCell) -> CGFloat? {
		return (cell as? CellType)?.height(with: item)
	}
	
	public func estimatedHeight(_ cell: UITableViewCell) -> CGFloat? {
		return (cell as? CellType)?.estimatedHeight(with: item)
	}
	
    // MARK: - RowActionable -
    
    public func invoke(action: TableRowActionType, cell: UITableViewCell?, path: IndexPath, userInfo: [AnyHashable: Any]? = nil) -> Any? {

        return actions[action.key]?.compactMap({ $0.invokeActionOn(cell: cell, item: item, path: path, userInfo: userInfo) }).last
    }
    
    public func has(action: TableRowActionType) -> Bool {
        
        return actions[action.key] != nil
    }
    
    public func isEditingAllowed(forIndexPath indexPath: IndexPath) -> Bool {
        
        if actions[TableRowActionType.canEdit.key] != nil {
            return invoke(action: .canEdit, cell: nil, path: indexPath) as? Bool ?? false
        }
        return editingActions?.isEmpty == false || actions[TableRowActionType.clickDelete.key] != nil
    }
    
    // MARK: - actions -
    
    @discardableResult
    public func on(_ action: TableRowAction<CellType>) -> Self {

        if actions[action.type.key] == nil {
            actions[action.type.key] = [TableRowAction<CellType>]()
        }
        actions[action.type.key]?.append(action)
        
        return self
    }

    @discardableResult
    public func on<T>(_ type: TableRowActionType, handler: @escaping (_ options: TableRowActionOptions<CellType>) -> T) -> Self {
        
        return on(TableRowAction<CellType>(type, handler: handler))
    }
    
    @discardableResult
    public func on(_ key: String, handler: @escaping (_ options: TableRowActionOptions<CellType>) -> ()) -> Self {
        
        return on(TableRowAction<CellType>(.custom(key), handler: handler))
    }

    public func removeAllActions() {
        
        actions.removeAll()
    }
    
    public func removeAction(forActionId actionId: String) {

        for (key, value) in actions {
            if let actionIndex = value.index(where: { $0.id == actionId }) {
                actions[key]?.remove(at: actionIndex)
            }
        }
    }
}
