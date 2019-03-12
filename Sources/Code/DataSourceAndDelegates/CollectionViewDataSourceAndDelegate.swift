//
//  CollectionViewDataSourceAndDelegate.swift
//  TableKit
//
//  Created by Лакомов А.Ю. on 12/03/2019.
//  Copyright © 2019 Max Sokolov. All rights reserved.
//

import UIKit

class CollectionViewDataSourceAndDelegate: NSObject, SheetDelegateAndDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
	var displayedSections: SafeArray<STKSection> { return SafeArray<STKSection>(sections.compactMap { $0 as STKSection }) }
	
	
	/// MARK: SheetDelegateAndDataSource
	unowned let delegate: SheetDelegateAndDataSourceDelegate
	private let collectionView: UICollectionView
	
	private var sections = SafeArray<STKCollectionSection>()
	
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
		return sections[safe: section]?.items.count ?? 0
	}
	

	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let row = sections[indexPath.section].items[indexPath.row]
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
		_ = delegate.invoke(action: .move, cell: collectionView.cellForItem(at: sourceIndexPath), indexPath: sourceIndexPath, userInfo: [STKUserInfoKeys.cellMoveDestinationIndexPath: destinationIndexPath])
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
	// MARK: - UICollectionViewDelegate
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath)
		
		if delegate.invoke(action: .click, cell: cell, indexPath: indexPath) != nil {
			collectionView.deselectItem(at: indexPath, animated: true)
		} else {
			_ = delegate.invoke(action: .select, cell: cell, indexPath: indexPath)
		}
	}
	
	public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		_ = delegate.invoke(action: .deselect, cell: collectionView.cellForItem(at: indexPath), indexPath: indexPath)
	}
	
	public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		_ = delegate.invoke(action: .willDisplay, cell: collectionView.cellForItem(at: indexPath), indexPath: indexPath)
	}
	
	public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		_ = delegate.invoke(action: .didEndDisplaying, cell: collectionView.cellForItem(at: indexPath), indexPath: indexPath)
	}
}

// MARK: - SheetDataUpdatingProtocol
extension CollectionViewDataSourceAndDelegate: SheetDataUpdatingProtocol {
	
	func synchronizeDelegates() {
		let sections = self.sections
		self.collectionView.visibleCells.forEach {
			guard let path =  self.collectionView.indexPath(for: $0), let row = sections[safe: path.section]?.items[safe: path.row] else {
				return
			}
			row.setupCustomActionDelegate(for: $0, indexPath: path)
		}
	}
	
	func reload(sections: SafeArray<STKSection>, completion: @escaping () -> Void) {
		update(sections: sections)
		collectionView.reloadData()
		completion()
	}
	
	func reload(sections: SafeArray<STKSection>, animations: TableAnimations, completion: @escaping () -> Void) {
		update(sections: sections)
		collectionView.performBatchUpdates({
			
		}) { (finished) in
			
		}
	}
	
	private func update(sections: SafeArray<STKSection>) {
		self.sections = SafeArray<STKCollectionSection>(sections.compactMap{ $0.copy() as? STKCollectionSection})
	}
}
