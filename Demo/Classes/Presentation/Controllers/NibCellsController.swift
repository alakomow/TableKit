import UIKit
import SbisTableKit

class NibCellsController: UITableViewController {
    
    var tableDirector: TableManager<UITableView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nib cells"
        
		tableDirector = TableManager(sheet: tableView)
        
        let numbers = [1000, 2000, 3000, 4000, 5000]

        let rows = numbers.map {
            TableRow<NibTableViewCell>(item: $0)
                .on(.shouldHighlight { (_) -> Bool in
                    return false
                })
        }
		
		let section = TableSection(rows: rows)
        tableDirector.sections.append(element: section)
    }
}
