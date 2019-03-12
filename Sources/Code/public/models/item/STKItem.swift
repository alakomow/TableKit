
import UIKit

/// Реализация модели данных, для хранения информации, необходимой для отображения ячейки.
final public class STKItem<CellType: STKCell>: STKItemProtocol {
	
	public let item: CellType.CellData
	private lazy var actions = [STKItemActionType: STKItemAction<CellType>]()

	public var cellIdentifier: String {
		return CellType.reuseIdentifier
	}
	
	public var nib: UINib? {
		return CellType.nib
	}
	
	public var cellType: AnyClass  {
		return CellType.self
	}
	
	public init(item: CellType.CellData, actions: [STKItemAction<CellType>]? = nil) {
	
		self.item = item
		actions?.forEach { on($0) }
	}
	
	public func copy() -> STKItemProtocol {
		return STKItem<CellType>(item: item, actions: actions.values.map({ return $0 }))
	}
	
	// MARK: - RowConfigurable -
	
	public var ID: Int { return item.identifier }
	
	public var dataHashValue: Int {
		return item.propertiesHashValue
	}
	
	public func configure(_ cell: UIView, indexPath: IndexPath) {
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

	public func invoke(action: STKItemActionType, cell: UIView?, path: IndexPath, userInfo: [STKUserInfoKeys : Any]? = nil) -> Any? {
		if action == .willDisplay {
			setupCustomActionDelegate(for: cell, indexPath: path)
		}
		return actions[action]?.invoke(options: TSKItemActionData(item: item, cell: cell as? CellType, path: path, userInfo: userInfo))
	}

	public func isEditingAllowed(forIndexPath indexPath: IndexPath) -> Bool {
		return invoke(action: STKItemActionType.canEdit, cell: nil, path: indexPath) as? Bool ?? false
	}

	// MARK: - actions -

	@discardableResult
	public func on(_ action: STKItemAction<CellType>) -> Self {
		actions[action.key] = action
		return self
	}
	public func removeAllActions() {
	
		actions.removeAll()
	}
}

extension STKItem: STKCellDelegate {
	public func customAction<CellType>(cell: CellType, actionString: String) where CellType : STKCell {
		guard let indexPath = cell.indexPath else { return }
		_ = invoke(action: STKItemActionType.custom(actionString), cell: cell as? UIView, path: indexPath)
	}
}

extension STKItem: CustomDebugStringConvertible where CellType.CellData: CustomDebugStringConvertible{
	public var debugDescription: String {
		return "\nRow: \(Unmanaged.passUnretained(self).toOpaque()); \n" +
			" ID: \(ID) \n" +
			" cellIdentifier: \(cellIdentifier) \n" +
			" item: \(type(of: item)) - '\(item.debugDescription)' \n" +
			" actions: \(actions) \n"
	}
}
