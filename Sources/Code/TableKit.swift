
import UIKit

public enum STKUserInfoKeys {
	case cellMoveDestinationIndexPath
	case cellCanMoveProposedIndexPath
}

public protocol STKItemConfigurable {
	var ID: Int { get }
	var dataHashValue: Int { get }
	func configure(_ cell: UIView, indexPath: IndexPath)
	func estimatedHeight(for cell: UIView) -> CGFloat?
	func height(for cell: UIView) -> CGFloat?
	func setupCustomActionDelegate(for cell: UIView?, indexPath: IndexPath)
}

public protocol STKItemActionable {
	func isEditingAllowed(forIndexPath indexPath: IndexPath) -> Bool
	
	func invoke(
		action: STKItemActionType,
		cell: UIView?,
		path: IndexPath,
		userInfo: [STKUserInfoKeys: Any]?) -> Any?
}

public protocol STKItemProtocol: STKItemConfigurable, STKItemActionable {
	
	var cellIdentifier: String { get }
	var nib: UINib? { get }
	var cellType: AnyClass { get }
	
	func copy() -> STKItemProtocol
}
