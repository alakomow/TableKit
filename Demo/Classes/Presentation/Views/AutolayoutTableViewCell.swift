import UIKit
import SbisTableKit

private let LoremIpsumTitle = "Lorem ipsum dolor sit amet, consectetur adipisicing elit"

class AutolayoutTableViewCell: UITableViewCell, SbisTableKitCell {
	weak var customCellActionDelegate: SbisTableKitCellDelegate?
	
	var indexPath: IndexPath?
	
    
    typealias T = String
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!

    static var estimatedHeight: CGFloat? {
        return 150
    }

    func configure(with string: T) {
        
        titleLabel.text = LoremIpsumTitle
        subtitleLabel.text = string
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layoutIfNeeded()
        
        titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.size.width
        subtitleLabel.preferredMaxLayoutWidth = subtitleLabel.bounds.size.width
    }
}

extension String: SbisTableKitViewModel {
	public var identifier: Int {
		return self.hashValue
	}
	
	public var propertiesHashValue: Int {
		return identifier
	}
	
	
}
