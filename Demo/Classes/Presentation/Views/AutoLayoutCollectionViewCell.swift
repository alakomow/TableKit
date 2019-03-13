//
//  AutoLayoutCollectionViewCell.swift
//  SbisTableKitDemo
//
//  Created by Лакомов А.Ю. on 13/03/2019.
//  Copyright © 2019 Tensor. All rights reserved.
//

import UIKit
import SbisTableKit

class AutoLayoutCollectionViewCell: UICollectionViewCell {
	
	struct Actions {
		static let customAction1 = "customAction1"
	}
	
	@IBOutlet weak var label1: UILabel!
	@IBOutlet weak var label2: UILabel!
	
	weak var customCellActionDelegate: STKCellDelegate?
	var indexPath: IndexPath?
	@IBAction func customAction(_ sender: Any) {
		customCellActionDelegate?.customAction(cell: self, actionString: Actions.customAction1)
	}
}

extension AutoLayoutCollectionViewCell: STKCell {
	func configure(with model: AutoLayoutCollectionViewCellModel) {
		label1.text = model.title1
		label2.text = model.title2
	}
}


struct AutoLayoutCollectionViewCellModel {
	
	let ID: Int
	let title1: String
	let title2: String
}

extension AutoLayoutCollectionViewCellModel: STKViewModel {
	var identifier: Int {
		return ID
	}
	
	var propertiesHashValue: Int {
		return title1.hashValue ^ title2.hashValue
	}
}
