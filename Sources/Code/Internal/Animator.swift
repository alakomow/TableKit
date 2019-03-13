//
//  Animator.swift
//  SbisTableKit
//
//  Created by Лакомов А.Ю. on 05/03/2019.
//
//

import Foundation


class STKAnimatebleSection: TableAnimatorSection {
	
	let identifier: Int
	let cells: [STKAnimatableCell]
	
	convenience init(_ section: STKSection) {
		self.init(section.identifier, cells: section.items.map { STKAnimatableCell($0.ID) })
	}
	
	init(_ identifier: Int, cells: [STKAnimatableCell]) {
		self.identifier = identifier
		self.cells = cells
	}
	
	static func == (lhs: STKAnimatebleSection, rhs: STKAnimatebleSection) -> Bool {
		return lhs.identifier == rhs.identifier
	}
}

class STKAnimatableCell: TableAnimatorCell {
	let identifier: Int
	
	init(_ identifier: Int) {
		self.identifier = identifier
	}
	
	static func == (lhs: STKAnimatableCell, rhs: STKAnimatableCell) -> Bool {
		return lhs.identifier == rhs.identifier
	}
	
	var hashValue: Int { return identifier }
}
