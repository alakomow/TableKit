//
//  Animator.swift
//  TableKit
//
//  Created by Лакомов А.Ю. on 05/03/2019.
//
//

import Foundation

class Animator {
	
	enum ItemAction {
		case insert
		case remove
		case update
	}
	
	struct ReloadData {
		let path: [IndexPath]
		let animation: ItemAction
	}
	

	typealias AnimateRow = (index: IndexPath,action: ItemAction)
	func split(current: [TableSection], new: [TableSection], visibleIndexPaths: [IndexPath]) -> [AnimateRow] {
		
		var rows: [AnimateRow] = []

		
		for indexPath in visibleIndexPaths {
			let oldElement = current[indexPath.section].rows[indexPath.row]
			/// Если в новых данных нет элемента, значит нужно удалять.
			guard let newElement = new[safe: indexPath.section]?.rows[safe: indexPath.row] else {
				rows.append((indexPath,.remove))
				continue
			}
			/// Если это татже елемент - обновляем
			if oldElement.ID == newElement.ID {
				rows.append((indexPath, .update))
			/// Если елемент присутствует в новом масиве.
			} else if let path = new.indexPath(for: oldElement) {
				/// Если елемент был перемещен в зоне видимости
				if visibleIndexPaths.contains(path) {
					rows.append((indexPath, .insert))
				}
				rows.append((path, .remove))
			}
		}
		let newIndexPaths = new.indexPaths(after: nil)
		let oldIndexPaths = current.indexPaths(after: nil)
		let rowsIndexPaths = rows.map { $0.index }
		
		let addPaths = newIndexPaths.filter { !oldIndexPaths.contains($0) && !rowsIndexPaths.contains($0) }
		let removePaths = oldIndexPaths.filter { !newIndexPaths.contains($0) && !rowsIndexPaths.contains($0) }
		
		rows.append(contentsOf: addPaths.map { ($0, .insert) })
		rows.append(contentsOf: removePaths.map { ($0, .remove)})
		return rows
	}
}

extension Array  {
	fileprivate subscript (safe index: Index) -> Element? {
		guard index >= 0 && index < self.count else { return nil }
		return self[index]
	}
}

extension Array where Element: TableSection  {
	fileprivate func indexPath(for item: Row) -> IndexPath? {
		for (sectionIndex, section) in self.enumerated() {
			if let index = section.rows.map( { return $0 }).firstIndex(where: { item.ID == $0.ID }) {
				return IndexPath(row: index, section: sectionIndex)
			}
		}
		return nil
	}
	
	fileprivate func indexPaths(after indexPath: IndexPath?) -> [IndexPath] {
		let indexPath = indexPath ?? IndexPath(row: 0, section: 0)
		var rows = [IndexPath]()
		for (sectionIndex, section) in self.enumerated() {
			if sectionIndex < indexPath.section { continue }
			for (rowIndex, _ ) in section.rows.enumerated() {
				if sectionIndex == indexPath.section && rowIndex < indexPath.row { continue }
				rows.append(IndexPath(row:rowIndex, section: sectionIndex))
			}
		}
		return rows
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class AnimatebleSection: TableAnimatorSection {
	
	let identifier: Int
	let cells: [AnimatableCell]
	
	convenience init(_ section: TableSection) {
		self.init(section.identifier, cells: section.rows.map { AnimatableCell($0.ID) })
	}
	
	init(_ identifier: Int, cells: [AnimatableCell]) {
		self.identifier = identifier
		self.cells = cells
	}
	
	static func == (lhs: AnimatebleSection, rhs: AnimatebleSection) -> Bool {
		return lhs.identifier == rhs.identifier
	}
}

class AnimatableCell: TableAnimatorCell {
	let identifier: Int
	
	init(_ identifier: Int) {
		self.identifier = identifier
	}
	
	static func == (lhs: AnimatableCell, rhs: AnimatableCell) -> Bool {
		return lhs.identifier == rhs.identifier
	}
	
	var hashValue: Int { return identifier }
}
