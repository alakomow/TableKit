

import UIKit

public class STKManager<TableType> {
	public  let sections = STKSafeArray<STKSection>()
	private let cellRegisterer: TableCellRegisterer?
	private let animator = TableAnimator<STKAnimatebleSection>()
	private let table: STKTable
	private lazy var dataSourceAndDelegate: STKDelegateAndDataSource? = {
		return TableViewDataSourceAndDelegate(table: table, delegate: self) ?? CollectionViewDataSourceAndDelegate(table: table, delegate: self)
	}()
	
	public init?( table: TableType) {
		guard let table = table as? STKTable else { return nil }
		
		self.table = table
		self.cellRegisterer = TableCellRegisterer(table: table)
		self.sections.elementsDidSetBlock = { [weak self] in
			self?.sections.forEach { self?.addHandler(section: $0) }
			self?.synchronizeSections()
		}
	}
}

extension STKManager: STKDelegateAndDataSourceDelegate {
	
	func register(row: STKItemProtocol?, for indexPath: IndexPath) {
		guard let row = row, row.needCellRegistration else { return }
		cellRegisterer?.register(row, indexPath: indexPath)
	}
	
	func prototypeCell<T>(for row: STKItemProtocol, indexPath: IndexPath) -> T? {
		return cellRegisterer?.prototypeCell(for: row, indexPath: indexPath)
	}
}

extension STKManager {
	
	private func addHandler(section: STKSection) {
		section.didChangeRowsBlock = { [weak self] in
			self?.synchronizeSections()
		}
	}
	
	private func synchronizeSections() {
		
		if hasDublicates() {
			dataSourceAndDelegate?.reload(sections: sections, completion: {
				self.dataSourceAndDelegate?.synchronizeDelegates()
			})
			return
		}
		_ = dataSourceAndDelegate
		let from = dataSourceAndDelegate?.displayedSections.map { STKAnimatebleSection($0) } ?? []
		let to = sections.map { STKAnimatebleSection($0) }
		//TODO: - Обрабатывать ошибку так. Сейчас по факту она не должна возникнуть, потому что выше проверяется.
		var animations = try! animator.buildAnimations(from: from, to: to)
		
		
		let visiblePath = dataSourceAndDelegate?.visibleIndexPaths() ?? []
		let animationPaths = (animations.cells.toDeferredUpdate +
			animations.cells.toDelete +
			animations.cells.toInsert +
			animations.cells.toMove.flatMap { return [$0,$1] } +
			animations.cells.toUpdate)
			
		let pathsForUpdate = visiblePath.filter {
			guard !animationPaths.contains($0), let newRow = self.sections.item(for: $0), let curRow = dataSourceAndDelegate?.displayedSections.item(for: $0) else {
				return false
			}
			if newRow.dataHashValue == curRow.dataHashValue {
				return false
			}
			return true
			
		}
		animations.cells.toDeferredUpdate.append(contentsOf: pathsForUpdate)
		
		dataSourceAndDelegate?.reload(sections: sections, animations: animations, completion: {
			self.dataSourceAndDelegate?.synchronizeDelegates()
		})
	}
	
	/// Все элементы должны быть уникальны, иначе аниматору будет плохо, и всеравно все упадет
	private func hasDublicates() -> Bool {
		return hasSectionDublicates() || hasElementDublicates()
	}
	
	private func hasSectionDublicates() -> Bool {
		return sections.count != Set(sections.map { return $0 }).count
	}
	
	private func hasElementDublicates() -> Bool {
		let allElements = sections.flatMap { $0.items.map { $0.ID } }
		return allElements.count != Set(allElements).count
	}
}

protocol STKDelegateAndDataSourceUpdatingProtocol {
	func synchronizeDelegates()
	func reload(sections: STKSafeArray<STKSection>, completion: @escaping () -> Void)
	func reload(sections: STKSafeArray<STKSection>, animations: TableAnimations, completion: @escaping () -> Void)
}

protocol STKDelegateAndDataSourceDelegate: class {
	func register(row: STKItemProtocol?, for indexPath: IndexPath)
	func prototypeCell<T>(for row: STKItemProtocol, indexPath: IndexPath) -> T?
}

protocol STKDelegateAndDataSource: STKDelegateAndDataSourceUpdatingProtocol {
	var delegate: STKDelegateAndDataSourceDelegate { get }
	var displayedSections: STKSafeArray<STKSection> { get }
	init?(table: STKTable, delegate: STKDelegateAndDataSourceDelegate)
	
	func visibleIndexPaths() -> [IndexPath]
}
