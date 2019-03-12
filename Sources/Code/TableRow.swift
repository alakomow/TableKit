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

public class TableRow<CellType: SbisTableKitCell>: Row {
	
	public let item: CellType.CellData
	private lazy var actions = [TableRowActionType: TableRowAction<CellType>]()

	public var cellIdentifier: String {
		return CellType.reuseIdentifier
	}
	
	public var nib: UINib? {
		return CellType.nib
	}
	
	public var cellType: AnyClass  {
		return CellType.self
	}
	
	public init(item: CellType.CellData, actions: [TableRowAction<CellType>]? = nil) {
	
		self.item = item
		actions?.forEach { on($0) }
	}
	
	public func copy() -> Row {
		return TableRow<CellType>(item: item, actions: actions.values.map({ return $0 }))
	}
	
	// MARK: - RowConfigurable -
	
	public var ID: Int { return item.identifier }
	
	public var dataHashValue: Int {
		return item.propertiesHashValue
	}
	
	open func configure(_ cell: UIView, indexPath: IndexPath) {
		setupCustomActionDelegate(for: cell, indexPath: indexPath)
		guard let cell = cell as? CellType else { return }
		cell.configure(with: item)
		cell.indexPath = indexPath
		
	}
	
	public func setupCustomActionDelegate(for cell: UIView?, indexPath: IndexPath) {
		guard let cell = cell as? CellType else { return }
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

	public func invoke(action: TableRowActionType, cell: UIView?, path: IndexPath, userInfo: [TableKitUserInfoKeys : Any]? = nil) -> Any? {
		if action == .willDisplay {
			setupCustomActionDelegate(for: cell, indexPath: path)
		}
		return actions[action]?.invoke(options: TableRowActionOptions(item: item, cell: cell as? CellType, path: path, userInfo: userInfo))
	}

	public func isEditingAllowed(forIndexPath indexPath: IndexPath) -> Bool {
		return invoke(action: TableRowActionType.canEdit, cell: nil, path: indexPath) as? Bool ?? false
	}

	// MARK: - actions -

	@discardableResult
	public func on(_ action: TableRowAction<CellType>) -> Self {
		actions[action.key] = action
		return self
	}
	public func removeAllActions() {
	
		actions.removeAll()
	}
}

extension TableRow: ConfigurableCellDelegate {
	public func customAction<CellType>(cell: CellType, actionString: String) where CellType : SbisTableKitCell {
		guard let indexPath = cell.indexPath else { return }
		_ = invoke(action: TableRowActionType.custom(actionString), cell: cell as? UIView, path: indexPath)
	}
}

extension TableRow: CustomDebugStringConvertible where CellType.CellData: CustomDebugStringConvertible{
	public var debugDescription: String {
		return "\nRow: \(Unmanaged.passUnretained(self).toOpaque()); \n" +
			" ID: \(ID) \n" +
			" cellIdentifier: \(cellIdentifier) \n" +
			" item: \(type(of: item)) - '\(item.debugDescription)' \n" +
			" actions: \(actions) \n"
	}
}
