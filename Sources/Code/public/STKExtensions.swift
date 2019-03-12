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

extension UITableView: STKTable {
	public func register(nib: UINib, identifier: String, indexPath: IndexPath) -> UIView? {
		register(nib, forCellReuseIdentifier: identifier)
		return dequeueReusableCell(withIdentifier: identifier)
	}
	
	public func register(type: AnyClass, identifier: String, indexPath: IndexPath) -> UIView? {
		guard let cell = self.dequeueReusableCell(withIdentifier: identifier) else {
			register(type, forCellReuseIdentifier: identifier)
			return dequeueReusableCell(withIdentifier: identifier)
		}
		return cell
	}
	
	
}

extension UICollectionView: STKTable {
	public func register(nib: UINib, identifier: String, indexPath: IndexPath) -> UIView? {
		register(nib, forCellWithReuseIdentifier: identifier)
		return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
	}
	
	public func register(type: AnyClass, identifier: String, indexPath: IndexPath) -> UIView? {
		register(type, forCellWithReuseIdentifier: identifier)
		return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
	}
}
