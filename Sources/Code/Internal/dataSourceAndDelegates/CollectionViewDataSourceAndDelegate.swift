//
//  CollectionViewDataSourceAndDelegate.swift
//  TableKit
//
//  Created by Лакомов А.Ю. on 12/03/2019.
//  Copyright © 2019 Max Sokolov. All rights reserved.
//

import UIKit

class CollectionViewDataSourceAndDelegate: NSObject, STKDelegateAndDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	var displayedSections: STKSafeArray<STKSection> { return STKSafeArray<STKSection>(sections.compactMap { $0 as STKSection }) }
	
	
	/// MARK: SheetDelegateAndDataSource
	unowned let delegate: STKDelegateAndDataSourceDelegate
	private let collectionView: UICollectionView
	
	private var sections = STKSafeArray<STKCollectionSection>()
	
	required init?(table: STKTable, delegate: STKDelegateAndDataSourceDelegate) {
		guard let collectionView = table as? UICollectionView else { return nil }
		
		self.delegate = delegate
		self.collectionView = collectionView
		super.init()
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.reloadData()
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
		_ = sections.item(for: indexPath)?.invoke(action: .configure, cell: cell, path: indexPath, userInfo: nil)
		
		return cell
	}
	
	
	public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard let element = sections[indexPath.section].supplementaryView(for: kind) else { return UICollectionReusableView() }
		let viewElement = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: element.cellIdentifier, for: indexPath)
		element.configure(viewElement, indexPath: indexPath)
		_ = element.invoke(action: .configure, cell: viewElement, path: indexPath, userInfo: nil)
		return viewElement
	}

	public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
		return sections.item(for: indexPath)?.invoke(action: .canMove, cell: collectionView.cellForItem(at: indexPath), path: indexPath, userInfo: nil) as? Bool ?? false
	}
	
	public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		_ = sections.item(for: sourceIndexPath)?.invoke(action: .move, cell: collectionView.cellForItem(at: sourceIndexPath), path: sourceIndexPath, userInfo: [STKUserInfoKeys.cellMoveDestinationIndexPath: destinationIndexPath])
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
		
		if sections.item(for: indexPath)?.invoke(action: .click, cell: cell, path: indexPath, userInfo: nil) != nil {
			collectionView.deselectItem(at: indexPath, animated: true)
		} else {
			_ = sections.item(for: indexPath)?.invoke(action: .select, cell: cell, path: indexPath, userInfo: nil)
		}
	}
	
	public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		_ = sections.item(for: indexPath)?.invoke(action: .deselect, cell: collectionView.cellForItem(at: indexPath), path: indexPath, userInfo: nil)
	}
	
	public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		_ = sections.item(for: indexPath)?.invoke(action: .willDisplay, cell: collectionView.cellForItem(at: indexPath), path: indexPath, userInfo: nil)
	}
	
	public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		_ = sections.item(for: indexPath)?.invoke(action: .didEndDisplaying, cell: collectionView.cellForItem(at: indexPath), path: indexPath, userInfo: nil)
	}
	
	public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
		_ = sections[indexPath.section].supplementaryView(for: elementKind)?.invoke(action: .willDisplay, cell: view, path: indexPath, userInfo: nil)
	}

	public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
		_ = sections[indexPath.section].supplementaryView(for: elementKind)?.invoke(action: .didEndDisplaying, cell: view, path: indexPath, userInfo: nil)
	}
	
	// - MARK: UICollectionViewDelegateFlowLayout
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let defaultSize = (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? .zero
		
		
		guard let item = sections.item(for: indexPath), let cell: UICollectionViewCell = delegate.prototypeCell(for: item, indexPath: indexPath) else {
			return defaultSize
		}
		
		return item.invoke(action: .size, cell: cell, path: indexPath, userInfo: nil) as? CGSize ?? item.cellSize(for: cell) ?? defaultSize
	}
//
//	@available(iOS 6.0, *)
//	optional public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
//	
//	@available(iOS 6.0, *)
//	optional public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
//	
//	@available(iOS 6.0, *)
//	optional public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
//	
//	@available(iOS 6.0, *)
//	optional public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
//	
//	@available(iOS 6.0, *)
//	optional public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
}

// MARK: - SheetDataUpdatingProtocol
extension CollectionViewDataSourceAndDelegate: STKDelegateAndDataSourceUpdatingProtocol {
	
	func synchronizeDelegates() {
		let sections = self.sections
		self.collectionView.visibleCells.forEach {
			guard let path =  self.collectionView.indexPath(for: $0), let row = sections[safe: path.section]?.items[safe: path.row] else {
				return
			}
			row.setupCustomActionDelegate(for: $0, indexPath: path)
		}
	}
	
	func reload(sections: STKSafeArray<STKSection>, completion: @escaping () -> Void) {
		update(sections: sections)
		callOnMainThread {
			self.collectionView.reloadData()
			completion()
		}
	}
	
	func reload(sections: STKSafeArray<STKSection>, animations: TableAnimations, completion: @escaping () -> Void) {
		/// Баг https://openradar.appspot.com/28167779
		if self.sections.count < 1 {
			update(sections: sections)
			collectionView.reloadData()
			return
		}
		update(sections: sections)
		callOnMainThread {
			self.reload(sections: animations.sections, completion: {
				self.reload(cells: animations.cells, completion: {
					completion()
				})
			})
		}
	}
	
	private func reload(sections: SectionsAnimations, completion: @escaping () -> Void) {
		if sections.isEmpty {
			completion()
			return
		}
		collectionView.performBatchUpdates({
			collectionView.deleteSections(sections.toDelete)
			collectionView.insertSections(sections.toInsert)
			collectionView.reloadSections(sections.toUpdate)
			sections.toMove.forEach {
				collectionView.moveSection($0, toSection: $1)
			}
		}) { (finished) in
			completion()
		}
	}
	
	private func reload(cells: CellsAnimations, completion: @escaping () -> Void) {
		if cells.isEmpty {
			completion()
			return
		}
		collectionView.performBatchUpdates({
			collectionView.deleteItems(at: cells.toDelete)
			collectionView.insertItems(at: cells.toInsert)
			collectionView.reloadItems(at: cells.toUpdate)
			cells.toMove.forEach {
				self.collectionView.moveItem(at: $0, to: $1)
			}
		}) { (finished) in
			self.collectionView.performBatchUpdates({
				self.collectionView.reloadItems(at: cells.toDeferredUpdate)
			}, completion: { (finished) in
				completion()
			})
		}
	}
	
	private func update(sections: STKSafeArray<STKSection>) {
		self.sections.removeAll()
		self.sections.append(elements: sections.compactMap{ $0.copy() as? STKCollectionSection})
	}
	private func callOnMainThread(block: @escaping () -> Void) {
		Thread.isMainThread ? block() : DispatchQueue.main.async(execute: block)
	}
}

fileprivate extension STKCollectionSection {
	func supplementaryView(for kind: String) -> STKItemProtocol? {
		switch kind {
		case UICollectionView.elementKindSectionHeader:
			return header
		case UICollectionView.elementKindSectionFooter:
			return footer
		default:
			return nil
			
		}
	}
}
