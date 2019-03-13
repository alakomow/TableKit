import UIKit
import SbisTableKit

class NibCellsController: UITableViewController {
    
    var tableDirector: STKManager<UITableView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nib cells"
        
		tableDirector = STKManager(table: tableView)
        
        let numbers = [1000, 2000, 3000, 4000, 5000]

        let rows = numbers.map {
            STKItem<NibTableViewCell>(item: $0)
                .on(.shouldHighlight { (_) -> Bool in
                    return false
                })
        }
		
		let section = STKTableSection(rows: rows)
        tableDirector.sections.append(element: section)
    }
}
