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

open class TableRow<CellType: ConfigurableCell>: Row {
	
    public let item: CellType.CellData
    private lazy var actions = [TableRowActionType: TableRowAction<CellType>]()
    private(set) open var editingActions: [UITableViewRowAction]?
    
    open var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    open var reuseIdentifier: String {
        return CellType.reuseIdentifier
    }
	
	public var nib: UINib? {
		return CellType.nib
	}
	
	open var cellType: AnyClass  {
		return CellType.self
	}
	
	public init(item: CellType.CellData, actions: [TableRowAction<CellType>]? = nil, editingActions: [UITableViewRowAction]? = nil) {
	
	self.item = item
	self.editingActions = editingActions
	actions?.forEach { on($0) }
	}
	
	// MARK: - RowConfigurable -
	
	open func configure(_ cell: UIView, indexPath: IndexPath) {
		guard let cell = cell as? CellType else { return }
		cell.configure(with: item)
		cell.customCellActionDelegate = self
		cell.indexPath = indexPath
		
	}
	
	public func estimatedHeight(for cell: UIView) -> CGFloat? {
		return (cell as? CellType)?.estimatedHeight(with: item)
	}
	
	public func height(for cell: UIView) -> CGFloat? {
		return (cell as? CellType)?.height(with: item)
	}
    
    // MARK: - RowActionable -
    
	public func invoke(action: TableRowActionType, cell: UIView?, path: IndexPath, userInfo: [AnyHashable : Any]? = nil) -> Any? {
        return actions[action]?.invoke(options: TableRowActionOptions(item: item, cell: cell as? CellType, path: path, userInfo: userInfo))
    }
	public func has(action: TableRowActionType) -> Bool {
		return actions[action] != nil
    }
    
    open func isEditingAllowed(forIndexPath indexPath: IndexPath) -> Bool {
        
        if let result = invoke(action: TableRowActionType.canEdit, cell: nil, path: indexPath) as? Bool {
            return  result
        }
        return editingActions?.isEmpty == false
    }
    
    // MARK: - actions -
    
    @discardableResult
    open func on(_ action: TableRowAction<CellType>) -> Self {
		actions[action.key] = action
		return self
}
	open func removeAllActions() {
	
		actions.removeAll()
	}
}

extension TableRow: ConfigurableCellDelegate {
	public func customAction<CellType>(cell: CellType, actionString: String) where CellType : ConfigurableCell {
		guard let indexPath = cell.indexPath else { return }
		_ = invoke(action: TableRowActionType.custom(actionString), cell: cell as? UIView, path: indexPath)
	}
}
