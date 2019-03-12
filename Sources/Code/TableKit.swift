
import UIKit

public enum TableKitUserInfoKeys {
	case cellMoveDestinationIndexPath
	case cellCanMoveProposedIndexPath
}

public protocol RowConfigurable {
	var ID: Int { get }
	var dataHashValue: Int { get }
	func configure(_ cell: UIView, indexPath: IndexPath)
	func estimatedHeight(for cell: UIView) -> CGFloat?
	func height(for cell: UIView) -> CGFloat?
	func setupCustomActionDelegate(for cell: UIView?, indexPath: IndexPath)
}

public protocol RowActionable {
	func isEditingAllowed(forIndexPath indexPath: IndexPath) -> Bool
	
	func invoke(
		action: TableRowActionType,
		cell: UIView?,
		path: IndexPath,
		userInfo: [TableKitUserInfoKeys: Any]?) -> Any?
}

public protocol Row: RowConfigurable, RowActionable {
	
	var cellIdentifier: String { get }
	var nib: UINib? { get }
	var cellType: AnyClass { get }
	
	func copy() -> Row
}
