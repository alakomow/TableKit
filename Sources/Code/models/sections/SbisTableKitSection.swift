//
//  SheetSection.swift
//  Pods-TestUISequence
//
//  Created by Лакомов А.Ю. on 12/03/2019.
//

import Foundation

/// Базовый класс для работы с секциями
public class SbisTableKitSection {
	/// Уникальный идентификатор секции. Генерируется самостоятельно, но при острой необходимости можно указать свой при создании.
	let identifier: Int
	
	/// Массив моделей данных для генерации ячеек.
	public private(set) var items: SafeArray<SbisItem>
	
	
	public var indexTitle: String?
	
	public var numberOfRows: Int {
		return items.count
	}
	
	public var isEmpty: Bool {
		return items.isEmpty
	}
	
	var didChangeRowsBlock: (() -> Void)?
	
	public init(rows: [SbisItem] = [], identifier: Int? = nil) {
		self.identifier = identifier ?? UUID().uuidString.hashValue
		self.items = SafeArray(rows)
		
		self.items.elementsDidSetBlock = { [weak self] in
			self?.didChangeRowsBlock?()
		}
	}
	
	func copy() -> SbisTableKitSection {
		return  SbisTableKitSection(rows: items.map { return $0.copy() }, identifier: identifier)
	}
}

extension SbisTableKitSection: Hashable {
	public static func == (lhs: SbisTableKitSection, rhs: SbisTableKitSection) -> Bool {
		return lhs.identifier == rhs.identifier
	}
	
	public var hashValue: Int { return identifier }
}
