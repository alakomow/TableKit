import UIKit
import SbisTableKit

class MainController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
			tableDirector = TableManager(sheet: tableView)
        }
    }
    var tableDirector: TableManager<UITableView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TableKit"

        let clickAction = TableRowAction<ConfigurableTableViewCell>.click { [weak self] (options) in
            print("click", options.indexPath)
            switch options.indexPath.row {
            case 0:
                self?.performSegue(withIdentifier: "autolayoutcells", sender: nil)
            case 1:
                self?.performSegue(withIdentifier: "nibcells", sender: nil)
            default:
                break
            }
        }

        let rows = [

            STKItem<ConfigurableTableViewCell>(item: "Autolayout cells", actions: [clickAction]),
            STKItem<ConfigurableTableViewCell>(item: "Nib cells", actions: [clickAction])
        ]
		let section = STKTableSection(rows: rows)
        // automatically creates a section, also could be used like tableDirector.append(rows: rows)
        tableDirector.sections.append(element: section)
    }
}
