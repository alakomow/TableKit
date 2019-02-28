//
//  TableviewDirector.swift
//  TableKit
//
//  Created by Лакомов А.Ю. on 28/02/2019.
//  Copyright © 2019 Max Sokolov. All rights reserved.
//

import Foundation



class TableViewDelegateAndDataSource: NSObject {
	private weak var table: UITableView?
	private var sections: SafeArray<TableSection>
	
	init(tableView:UITableView, sections: [TableSection]) {
		self.table = tableView
		self.sections = SafeArray(sections)
	}
}

// MARK: - UITableViewDataSource -
extension TableViewDelegateAndDataSource: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[safe: section]?.rows.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
	}

	
	
	@available(iOS 2.0, *)
	optional public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? // fixed font style. use custom view (UILabel) if you want something different
	
	@available(iOS 2.0, *)
	optional public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
	
	
	// Editing
	
	// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
	@available(iOS 2.0, *)
	optional public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
	
	
	// Moving/reordering
	
	// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
	@available(iOS 2.0, *)
	optional public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
	
	
	// Index
	
	@available(iOS 2.0, *)
	optional public func sectionIndexTitles(for tableView: UITableView) -> [String]? // return list of section titles to display in section index view (e.g. "ABCD...Z#")
	
	@available(iOS 2.0, *)
	optional public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int // tell table which section corresponds to section title/index (e.g. "B",1))
	
	
	// Data manipulation - insert and delete support
	
	// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
	// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
	@available(iOS 2.0, *)
	optional public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
	
	
	// Data manipulation - reorder / moving support
	
	@available(iOS 2.0, *)
	optional public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

extension TableViewDelegateAndDataSource: UITableViewDelegate {
	
}
