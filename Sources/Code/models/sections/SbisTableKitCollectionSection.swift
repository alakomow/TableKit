//
//  CollectionSection.swift
//  TableKit
//
//  Created by Лакомов А.Ю. on 12/03/2019.
//  Copyright © 2019 Max Sokolov. All rights reserved.
//

import UIKit

final public class SbisTableKitCollectionSection: SbisTableKitSection {
	override func copy() -> SbisTableKitSection {
		let copy = SbisTableKitSection(rows: items.map { $0.copy() }, identifier: identifier)
		return copy
	}
}
