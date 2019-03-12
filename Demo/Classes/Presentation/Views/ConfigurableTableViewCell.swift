import UIKit
import SbisTableKit

class ConfigurableTableViewCell: UITableViewCell, STKCell {
	weak var customCellActionDelegate: STKCellDelegate?
	
	var indexPath: IndexPath?
	
    
    func configure(with text: String) {

        accessoryType = .disclosureIndicator
        textLabel?.text = text
    }
}
