import UIKit
import SbisTableKit

class MainController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
			tableDirector = STKManager(sheet: tableView)
        }
    }
    var tableDirector: STKManager<UITableView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TableKit"

        let clickAction = STKItemAction<ConfigurableTableViewCell>.click { [weak self] (options) in
            print("click", options.indexPath)
            switch options.indexPath.row {
            case 0:
                self?.performSegue(withIdentifier: "autolayoutcells", sender: nil)
            case 1:
                self?.performSegue(withIdentifier: "nibcells", sender: nil)
			case 2:
				self?.performSegue(withIdentifier: "openColiectionview", sender: nil)
            default:
                break
            }
        }

        let rows = [

            STKItem<ConfigurableTableViewCell>(item: "Autolayout cells", actions: [clickAction]),
            STKItem<ConfigurableTableViewCell>(item: "Nib cells", actions: [clickAction]),
			STKItem<ConfigurableTableViewCell>(item: "Collection View", actions: [clickAction])
        ]
		let section = STKTableSection(rows: rows)
        // automatically creates a section, also could be used like tableDirector.append(rows: rows)
        tableDirector.sections.append(element: section)
    }
}
