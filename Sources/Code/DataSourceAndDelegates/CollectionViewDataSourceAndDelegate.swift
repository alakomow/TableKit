//
//  CollectionViewDataSourceAndDelegate.swift
//  TableKit
//
//  Created by Лакомов А.Ю. on 12/03/2019.
//  Copyright © 2019 Max Sokolov. All rights reserved.
//

import UIKit

class CollectionViewDataSourceAndDelegate: NSObject, SheetDelegateAndDataSource, UICollectionViewDataSource {
	
	/// MARK: SheetDelegateAndDataSource
	unowned let delegate: SheetDelegateAndDataSourceDelegate
	private let collectionView: UICollectionView
	
	private var sections: SafeArray<TableSection> {
		return delegate.sheetSections()
	}
	
	required init?(table: SheetItemsRegistrationsProtocol, delegate: SheetDelegateAndDataSourceDelegate) {
		guard let collectionView = table as? UICollectionView else { return nil }
		
		self.delegate = delegate
		self.collectionView = collectionView
	}
	
	func visibleIndexPaths() -> [IndexPath] {
		return collectionView.indexPathsForVisibleItems
	}
	
	// MARK: - UICollectionViewDataSource
	
	public func numberOfSections(in collectionView: UICollectionView) -> Int {
		return sections.count
	}
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return sections[safe: section]?.rows.count ?? 0
	}
	

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let row = sections[indexPath.section].rows[indexPath.row]
		delegate.register(row: row, for: indexPath)
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: row.cellIdentifier, for: indexPath)
		row.configure(cell, indexPath: indexPath)
		_ = delegate.invoke(action: .configure, cell: cell, indexPath: indexPath)
		
		return cell
	}
	
	
//	public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//		collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: <#T##String#>, for: <#T##IndexPath#>)
//	}
//	
//	
//	@available(iOS 9.0, *)
//	optional public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool
//	
//	@available(iOS 9.0, *)
//	optional public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
//	
//	
//	/// Returns a list of index titles to display in the index view (e.g. ["A", "B", "C" ... "Z", "#"])
//	@available(iOS 6.0, *)
//	optional public func indexTitles(for collectionView: UICollectionView) -> [String]?
//	
//	
//	/// Returns the index path that corresponds to the given title / index. (e.g. "B",1)
//	/// Return an index path with a single index to indicate an entire section, instead of a specific item.
//	@available(iOS 6.0, *)
//	optional public func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath
}

// MARK: - SheetDataUpdatingProtocol
extension CollectionViewDataSourceAndDelegate: SheetDataUpdatingProtocol {
	
	func synchronizeDelegates() {
		let sections = self.sections
		self.collectionView.visibleCells.forEach {
			guard let path =  self.collectionView.indexPath(for: $0), let row = sections[safe: path.section]?.rows[safe: path.row] else {
				return
			}
			row.setupCustomActionDelegate(for: $0, indexPath: path)
		}
	}
	
	func reload(completion: @escaping () -> Void) {
		self.collectionView.reloadData()
		completion()
	}
	
	func reload(with animations: TableAnimations, completion: @escaping () -> Void) {
		self.collectionView.performBatchUpdates({
			
		}) { (finished) in
			
		}
	}
}
