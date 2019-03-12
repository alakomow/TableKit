//
//  Extensions.swift
//  TableKit
//
//  Created by Лакомов А.Ю. on 12/03/2019.
//  Copyright © 2019 Tensor. All rights reserved.
//

import UIKit

public extension STKCell where Self: UIView {
	
	static var reuseIdentifier: String {
		return String(describing: self)
	}
	
	static var nib: UINib? {
		let bundle = Bundle(for: self)
		guard let _ = bundle.path(forResource: reuseIdentifier, ofType: "nib") else { return nil }
		return UINib(nibName: reuseIdentifier, bundle: bundle)
	}
	
	func estimatedHeight(with: CellData) -> CGFloat? { return nil }
	func height(with: CellData) -> CGFloat? { return nil }
}
