//
//  Animator.swift
//  SbisTableKit
//
//  Created by Лакомов А.Ю. on 05/03/2019.
//
//

import Foundation


class AnimatebleSection: TableAnimatorSection {
	
	let identifier: Int
	let cells: [AnimatableCell]
	
	convenience init(_ section: STKSection) {
		self.init(section.identifier, cells: section.items.map { AnimatableCell($0.ID) })
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
