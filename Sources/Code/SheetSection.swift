//
//  SheetSection.swift
//  Pods-TestUISequence
//
//  Created by Лакомов А.Ю. on 12/03/2019.
//

import Foundation

public class SheetSection {
	let identifier: Int
	
	public private(set) var rows: SafeArray<Row>
	
	
	public var indexTitle: String?
	
	public var numberOfRows: Int {
		return rows.count
	}
	
	public var isEmpty: Bool {
		return rows.isEmpty
	}
	
	var didChangeRowsBlock: (() -> Void)?
	
	public init(rows: [Row] = [], identifier: Int? = nil) {
		self.identifier = identifier ?? UUID().uuidString.hashValue
		self.rows = SafeArray(rows)
		
		self.rows.elementsDidSetBlock = { [weak self] in
			self?.didChangeRowsBlock?()
		}
	}
	
	func copy() -> TableSection {
		return TableSection(rows: rows.map { return $0.copy() }, identifier: identifier)
	}
}

extension SheetSection: Hashable {
	public static func == (lhs: SheetSection, rhs: SheetSection) -> Bool {
		return lhs.identifier == rhs.identifier
	}
	
	public var hashValue: Int { return identifier }
}
