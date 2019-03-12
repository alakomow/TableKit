import UIKit
import SbisTableKit

class NibTableViewCell: UITableViewCell, STKCell {
	weak var customCellActionDelegate: STKCellDelegate?
	
	var indexPath: IndexPath?
	
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static var defaultHeight: CGFloat? {
        return 100
    }
    
    func configure(with number: Int) {
        titleLabel.text = "\(number)"
    }
}

extension Int: STKViewModel {
	public var identifier: Int {
		return self
	}
	
	public var propertiesHashValue: Int {
		return self
	}
	
	
}
