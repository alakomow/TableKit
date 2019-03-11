
import UIKit

public struct TableKitUserInfoKeys {
	public static let CellMoveDestinationIndexPath = "TableKitCellMoveDestinationIndexPath"
	public static let CellCanMoveProposedIndexPath = "CellCanMoveProposedIndexPath"
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
		userInfo: [AnyHashable: Any]?) -> Any?
}

public protocol Row: RowConfigurable, RowActionable {
	
	var cellIdentifier: String { get }
	var nib: UINib? { get }
	var cellType: AnyClass { get }
	
	func copy() -> Row
}
