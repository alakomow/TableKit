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
	
	public var headerTitle: String?
	public var footerTitle: String?
	public var indexTitle: String?
	
	public var headerView: UIView?
	public var footerView: UIView?
	
	public var headerHeight: CGFloat?
	public var footerHeight: CGFloat?
	
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
	
	public convenience init(headerTitle: String?, footerTitle: String?, rows: [Row] = []) {
		self.init(rows: rows)
		
		self.headerTitle = headerTitle
		self.footerTitle = footerTitle
	}
	
	public convenience init(headerView: UIView?, footerView: UIView?, rows: [Row] = []) {
		self.init(rows: rows)
		
		self.headerView = headerView
		self.footerView = footerView
	}
	
	func copy() -> TableSection {
		let copy = TableSection(rows: rows.map { return $0.copy() }, identifier: identifier)
		copy.headerView = headerView
		copy.footerView = footerView
		
		copy.headerTitle = headerTitle
		copy.footerTitle = footerTitle
		copy.indexTitle = indexTitle
		
		copy.headerHeight = headerHeight
		copy.footerHeight = footerHeight
		return copy
	}
}
