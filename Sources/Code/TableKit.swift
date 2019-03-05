
import UIKit

public struct TableKitUserInfoKeys {
	public static let CellMoveDestinationIndexPath = "TableKitCellMoveDestinationIndexPath"
	public static let CellCanMoveProposedIndexPath = "CellCanMoveProposedIndexPath"
}

public protocol RowConfigurable {
	
	func configure(_ cell: UIView, indexPath: IndexPath)
	func estimatedHeight(for cell: UIView) -> CGFloat?
	func height(for cell: UIView) -> CGFloat?
}

public protocol RowActionable {
	var editingActions: [UITableViewRowAction]? { get }
	func isEditingAllowed(forIndexPath indexPath: IndexPath) -> Bool
	
	func invoke(
		action: TableRowActionType,
		cell: UIView?,
		path: IndexPath,
		userInfo: [AnyHashable: Any]?) -> Any?
	
	func has(action: TableRowActionType) -> Bool
}

public protocol RowHashable {
	
	var hashValue: Int { get }
}

public protocol Row: RowConfigurable, RowActionable, RowHashable {
	
	var reuseIdentifier: String { get }
	var nib: UINib? { get }
	var cellType: AnyClass { get }
}
