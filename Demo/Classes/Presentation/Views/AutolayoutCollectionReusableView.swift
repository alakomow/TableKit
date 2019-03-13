//
//  AutolayoutCollectionReusableView.swift
//  SbisTableKitDemo
//
//  Created by Лакомов А.Ю. on 13/03/2019.
//  Copyright © 2019 Tensor. All rights reserved.
//

import UIKit
import SbisTableKit

class AutolayoutCollectionReusableView: UICollectionReusableView {
	var customCellActionDelegate: STKCellDelegate?
	var indexPath: IndexPath?
	
	@IBOutlet weak var title: UILabel!
}

extension AutolayoutCollectionReusableView: STKCell {
	func configure(with model: String) {
		title.text = model
	}
	
	func cellSize(with: String) -> CGSize? {
		return CGSize(width: 100, height: 20)
	}
}

