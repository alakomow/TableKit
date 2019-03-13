//
//  CollectionViewController.swift
//  SbisTableKitDemo
//
//  Created by Лакомов А.Ю. on 13/03/2019.
//  Copyright © 2019 Tensor. All rights reserved.
//

import UIKit
import SbisTableKit

class CollectionViewController: UIViewController {
	@IBOutlet weak var collectionView: UICollectionView!
	private var manager: STKManager<UICollectionView>!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		manager = STKManager(sheet: collectionView)
		
		let data = [
			AutoLayoutCollectionViewCellModel(ID: 1, title1: "Заголовок 1", title2: "Подзаголовок 1"),
			AutoLayoutCollectionViewCellModel(ID: 2, title1: "Заголовок 2", title2: "Подзаголовок 2"),
			AutoLayoutCollectionViewCellModel(ID: 3, title1: "Заголовок 3", title2: "Подзаголовок 3")
		]
		
		var rows: [STKItemProtocol] = []
		data.forEach {
			let row = STKItem<AutoLayoutCollectionViewCell>(item: $0, needCellRegistration: false)
			rows.append(row)
		}
		
		let section = STKCollectionSection(rows: rows)
		manager.sections.append(element: section)
    }
}
