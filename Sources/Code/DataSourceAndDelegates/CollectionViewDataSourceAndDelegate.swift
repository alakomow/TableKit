//
//  CollectionViewDataSourceAndDelegate.swift
//  TableKit
//
//  Created by Лакомов А.Ю. on 12/03/2019.
//  Copyright © 2019 Max Sokolov. All rights reserved.
//

import UIKit

class CollectionViewDataSourceAndDelegate: NSObject, SheetDelegateAndDataSource, UICollectionViewDataSource {
	var displayedSections: SafeArray<SheetSection> { return SafeArray<SheetSection>(sections.compactMap { $0 as SheetSection }) }
	
	
	/// MARK: SheetDelegateAndDataSource
	unowned let delegate: SheetDelegateAndDataSourceDelegate
	private let collectionView: UICollectionView
	
	private var sections = SafeArray<CollectionSection>()
	
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

	public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
		return delegate.invoke(action: .canMove, cell: collectionView.cellForItem(at: indexPath), indexPath: indexPath) as? Bool ?? false
	}
	
	public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		_ = delegate.invoke(action: .move, cell: collectionView.cellForItem(at: sourceIndexPath), indexPath: sourceIndexPath, userInfo: [TableKitUserInfoKeys.CellMoveDestinationIndexPath: destinationIndexPath])
	}
	
	public func indexTitles(for collectionView: UICollectionView) -> [String]? {
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
	
	func reload(sections: SafeArray<SheetSection>, completion: @escaping () -> Void) {
		update(sections: sections)
		collectionView.reloadData()
		completion()
	}
	
	func reload(sections: SafeArray<SheetSection>, animations: TableAnimations, completion: @escaping () -> Void) {
		update(sections: sections)
		collectionView.performBatchUpdates({
			
		}) { (finished) in
			
		}
	}
	
	private func update(sections: SafeArray<SheetSection>) {
		self.sections = SafeArray<CollectionSection>(sections.compactMap{ $0.copy() as? CollectionSection})
	}
}
