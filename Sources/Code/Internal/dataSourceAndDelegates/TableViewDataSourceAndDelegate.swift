//
//  TableviewDirector.swift
//  TableKit
//
//  Created by Лакомов А.Ю. on 28/02/2019.
//  Copyright © 2019 Max Sokolov. All rights reserved.
//

import UIKit

class TableViewDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate, SheetDelegateAndDataSource {
	var displayedSections: STKSafeArray<STKSection> { return STKSafeArray<STKSection>(sections.compactMap { $0 as STKSection }) }
	
	unowned let delegate: SheetDelegateAndDataSourceDelegate
	private unowned let tableView: UITableView
	
	private var sections = STKSafeArray<STKTableSection>()
	
	required init?(table: STKTable, delegate: SheetDelegateAndDataSourceDelegate) {
		guard let tableView = table as? UITableView else { return nil }
		
		self.tableView = tableView
		self.delegate = delegate
		super.init()
		
		tableView.dataSource = self
		tableView.delegate = self
		
		tableView.reloadData()
	}
	
	func visibleIndexPaths() -> [IndexPath] {
		return tableView.indexPathsForVisibleRows ?? []
	}

	// MARK: - UITableViewDataSource -
	public func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections[safe: section]?.items.count ?? 0
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let row = sections[indexPath.section].items[indexPath.row]
		delegate.register(row: row, for: indexPath)
		
		let cell = tableView.dequeueReusableCell(withIdentifier: row.cellIdentifier, for: indexPath)
		
		if cell.frame.size.width != tableView.frame.size.width {
			cell.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: cell.frame.size.height)
			cell.layoutIfNeeded()
		}
		row.configure(cell, indexPath: indexPath)
		_ = delegate.invoke(action: .configure, cell: cell, indexPath: indexPath)
		
		return cell
	}

	private func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sections[safe: section]?.headerTitle
	}
	
	private func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		return sections[safe: section]?.footerTitle
	}
	
	public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return sections[indexPath.section].items[indexPath.row].isEditingAllowed(forIndexPath: indexPath)
	}
	
	private func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return delegate.invoke(action: .canMove, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath) as? Bool ?? false
	}
	
	private func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		
		var indexTitles = [String]()
		var indexTitlesIndexes = [Int]()
		sections.enumerated().forEach { index, section in
			
			if let title = section.indexTitle {
				indexTitles.append(title)
				indexTitlesIndexes.append(index)
			}
		}
		return indexTitles
	}

	public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
		return index
	}
	
	
	public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			_ = delegate.invoke(action: .clickDelete, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath)
		}
	}
	
	
	private func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		_ = delegate.invoke(action: .move, cell: tableView.cellForRow(at: sourceIndexPath), indexPath: sourceIndexPath, userInfo: [STKUserInfoKeys.cellMoveDestinationIndexPath: destinationIndexPath])
	}
	
	// MARK: - UITableViewDelegate -
	public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		
		guard let row = sections[safe: indexPath.section]?.items[safe: indexPath.row], let cell: UITableViewCell = delegate.prototypeCell(for: row, indexPath: indexPath) else {
			return UITableView.automaticDimension
		}
		if let estimatedHeightFromActions = delegate.invoke(action: .estimatedHeight, cell: cell, indexPath: indexPath) as? CGFloat {
			return estimatedHeightFromActions
		}
		if let estimatedHeightFromRow = row.estimatedHeight(for: cell) {
			return estimatedHeightFromRow
		}
		
		return UITableView.automaticDimension
	}
	
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		guard let row = sections[safe: indexPath.section]?.items[safe: indexPath.row], let cell: UITableViewCell = delegate.prototypeCell(for: row, indexPath: indexPath) else {
			return UITableView.automaticDimension
		}
		if let heightFromActions = delegate.invoke(action: .height, cell: cell, indexPath: indexPath) as? CGFloat {
			return heightFromActions
		}
		if let heightFromRow = row.height(for: cell) {
			return heightFromRow
		}
		
		return UITableView.automaticDimension
	}
	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return sections[safe: section]?.headerView
	}
	
	public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return sections[safe: section]?.footerView
	}
	
	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		guard let section = sections[safe: section] else { return 0 }
		return section.headerHeight ?? section.headerView?.frame.size.height ?? UITableView.automaticDimension
	}
	
	public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		guard let section = sections[safe: section] else { return 0 }
		return section.footerHeight
			?? section.footerView?.frame.size.height
			?? UITableView.automaticDimension
	}
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		
		if delegate.invoke(action: .click, cell: cell, indexPath: indexPath) != nil {
			tableView.deselectRow(at: indexPath, animated: true)
		} else {
			_ = delegate.invoke(action: .select, cell: cell, indexPath: indexPath)
		}
	}
	
	public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		_ = delegate.invoke(action: .deselect, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath)
	}
	
	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		_ = delegate.invoke(action: .willDisplay, cell: cell, indexPath: indexPath)
	}
	
	public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		_ = delegate.invoke(action: .didEndDisplaying, cell: cell, indexPath: indexPath)
	}
	
	public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
		return delegate.invoke(action: .shouldHighlight, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath) as? Bool ?? true
	}
	
	public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return delegate.invoke(action: .willSelect, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath) as? IndexPath ?? indexPath
	}
	
	public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		return sections[indexPath.section].items[indexPath.row].invoke(action: .rowActions, cell: nil, path: indexPath, userInfo: nil) as? [UITableViewRowAction]
	}
	
	public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		if delegate.invoke(action: .canDelete, cell: tableView.cellForRow(at: indexPath), indexPath: indexPath) as? Bool ?? false {
			return UITableViewCell.EditingStyle.delete
		}
		
		return UITableViewCell.EditingStyle.none
	}
	
	public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
		return false
	}
	
	public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
		return delegate.invoke(action: .canMoveTo, cell: tableView.cellForRow(at: sourceIndexPath), indexPath: sourceIndexPath, userInfo: [STKUserInfoKeys.cellCanMoveProposedIndexPath: proposedDestinationIndexPath]) as? IndexPath ?? proposedDestinationIndexPath
	}
}

extension TableViewDataSourceAndDelegate: SheetDataUpdatingProtocol {
	
	
	func synchronizeDelegates() {
		let sections = self.sections
		self.tableView.visibleCells.forEach {
			guard let path = self.tableView.indexPath(for: $0), let row = sections[safe: path.section]?.items[safe: path.row] else {
				return
			}
			row.setupCustomActionDelegate(for: $0, indexPath: path)
		}
	}
	
	func reload(sections: STKSafeArray<STKSection>, completion: @escaping () -> Void) {
		update(sections: sections)
		tableView.reloadData()
		completion()
	}
	
	func reload(sections: STKSafeArray<STKSection>, animations: TableAnimations, completion: @escaping () -> Void) {
		update(sections: sections)
		if #available(iOS 11.0, *) {
			
			callOnMainThread {
				self.reload(sections: animations.sections, completion: {
					self.reload(cells: animations.cells, completion: {
						completion()
					})
				})
			}
		}
	}
	
	
	
	private func reload(sections: SectionsAnimations, completion: @escaping () -> Void) {
		if sections.isEmpty {
			completion()
			return
		}
		if #available(iOS 11.0, *) {
			tableView.performBatchUpdates({
				tableView.deleteSections(sections.toDelete, with: .fade)
				tableView.insertSections(sections.toInsert, with: .fade)
				tableView.reloadSections(sections.toUpdate, with: .fade)
				sections.toMove.forEach {
					tableView.moveSection($0, toSection: $1)
				}
			}) { (finished) in
				completion()
			}
		}
	}
	
	private func update(sections: STKSafeArray<STKSection>) {
		self.sections = STKSafeArray<STKTableSection>(sections.compactMap{ $0.copy() as? STKTableSection})
	}
	
	private func reload(cells: CellsAnimations, completion: @escaping () -> Void) {
		if cells.isEmpty {
			completion()
			return
		}
		if #available(iOS 11.0, *) {
			tableView.performBatchUpdates({
				tableView.deleteRows(at: cells.toDelete, with: .fade)
				tableView.insertRows(at: cells.toInsert, with: .fade)
				tableView.reloadRows(at: cells.toUpdate, with: .fade)
				cells.toMove.forEach {
					tableView.moveRow(at: $0, to: $1)
				}
			}) { (finished) in
				self.tableView.performBatchUpdates({
					self.tableView.reloadRows(at: cells.toDeferredUpdate, with: .fade)
				}, completion: { (finished) in
					completion()
				})
			}
		}
	}
	
	private func callOnMainThread(block: @escaping () -> Void) {
		Thread.isMainThread ? block() : DispatchQueue.main.async(execute: block)
	}
}
