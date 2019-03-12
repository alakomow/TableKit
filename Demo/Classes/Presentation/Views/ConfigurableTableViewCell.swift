import UIKit
import SbisTableKit

class ConfigurableTableViewCell: UITableViewCell, SbisTableKitCell {
	weak var customCellActionDelegate: SbisTableKitCellDelegate?
	
	var indexPath: IndexPath?
	
    
    func configure(with text: String) {

        accessoryType = .disclosureIndicator
        textLabel?.text = text
    }
}
