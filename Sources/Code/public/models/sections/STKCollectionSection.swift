//
//  CollectionSection.swift
//  TableKit
//
//  Created by Лакомов А.Ю. on 12/03/2019.
//  Copyright © 2019 Tensor. All rights reserved.
//

import UIKit

final public class STKCollectionSection: STKSection {
	
	public let header: STKItemProtocol?
	public let footer: STKItemProtocol?
	public let sectionInset: UIEdgeInsets?
	public let minimumLineSpacing: CGFloat?
	public let minimumInteritemSpacing: CGFloat?
	
	public init(rows: [STKItemProtocol],
				identifier: Int? = nil,
				header: STKItemProtocol? = nil,
				footer: STKItemProtocol? = nil,
				sectionInset: UIEdgeInsets? = nil,
				minimumLineSpacing: CGFloat? = nil,
				minimumInteritemSpacing: CGFloat? = nil) {
		self.header = header
		self.footer = footer
		self.sectionInset = sectionInset
		self.minimumLineSpacing = minimumLineSpacing
		self.minimumInteritemSpacing = minimumInteritemSpacing
		super.init(rows: rows, identifier: identifier)
	}
	
	override func copy() -> STKSection {
		let copy = STKCollectionSection(rows: items.map { $0.copy() },
										identifier: identifier,
										header: header,
										footer: footer,
										sectionInset: sectionInset,
										minimumLineSpacing: minimumLineSpacing,
										minimumInteritemSpacing: minimumInteritemSpacing)
		return copy
	}
}
