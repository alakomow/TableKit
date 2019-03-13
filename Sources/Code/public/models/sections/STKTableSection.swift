
import UIKit

final public class STKTableSection: STKSection {
	public var headerTitle: String?
	public var footerTitle: String?
	
	public var headerView: UIView?
	public var footerView: UIView?
	
	public var headerHeight: CGFloat?
	public var footerHeight: CGFloat?
	
	public convenience init(headerTitle: String?, footerTitle: String?, rows: [STKItemProtocol] = [], identifier: Int? = nil) {
		self.init(rows: rows, identifier: identifier)
		
		self.headerTitle = headerTitle
		self.footerTitle = footerTitle
	}
	
	public convenience init(headerView: UIView?, footerView: UIView?, rows: [STKItemProtocol] = [], identifier: Int? = nil) {
		self.init(rows: rows, identifier: identifier)
		
		self.headerView = headerView
		self.footerView = footerView
	}
	
	override func copy() -> STKTableSection {
		let copy = STKTableSection(rows: items.map { $0.copy() }, identifier: identifier)
		copy.headerView = headerView
		copy.footerView = footerView
		
		copy.headerTitle = headerTitle
		copy.footerTitle = footerTitle
		copy.indexTitle = indexTitle
		
		copy.headerHeight = headerHeight
		copy.footerHeight = footerHeight
		return copy
	}
}
