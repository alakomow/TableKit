//
//  CollectionSection.swift
//  TableKit
//
//  Created by Лакомов А.Ю. on 12/03/2019.
//  Copyright © 2019 Tensor. All rights reserved.
//

import UIKit

final public class STKCollectionSection: STKSection {
	override func copy() -> STKSection {
		let copy = STKCollectionSection(rows: items.map { $0.copy() }, identifier: identifier)
		return copy
	}
}
