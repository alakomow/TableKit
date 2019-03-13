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
		manager = STKManager(table: collectionView)
		
		let data = [
			AutoLayoutCollectionViewCellModel(ID: 1, title1: "Заголовок 1", title2: "Подзаголовок 1"),
			AutoLayoutCollectionViewCellModel(ID: 2, title1: "Заголовок 2", title2: "Подзаголовок 2"),
			AutoLayoutCollectionViewCellModel(ID: 3, title1: "Заголовок 3", title2: "Подзаголовок 3")
		]
		
		var rows: [STKItemProtocol] = []
		data.forEach {
			rows.append(row(for: $0))
		}
		
		let section = STKCollectionSection(rows: rows)
		manager.sections.append(element: section)
    }
	
	private func row(for model: AutoLayoutCollectionViewCellModel) -> STKItemProtocol {
		let row = STKItem<AutoLayoutCollectionViewCell>(item: model, needCellRegistration: false)
		row.on(.click {[weak self] (options) in
			guard let sself = self, let section = self?.manager.sections[safe: options.indexPath.section] else { return }
			let newModel = sself.makeViewModel(ID: model.ID)
			let newRow = sself.row(for: newModel)
			section.items.replace(at: options.indexPath.item, with: newRow)
			
			let newSection = STKCollectionSection(rows: [sself.row(for: sself.makeViewModel()),sself.row(for: sself.makeViewModel())])
			sself.manager.sections.append(element: newSection)
		})
		.on(.custom(AutoLayoutCollectionViewCell.Actions.customAction1) { [weak self] (options) in
			self?.makeAlert()
		})
		.on(.size { [weak self] (_) in
			
			return CGSize(width: self?.collectionView.bounds.width ?? 100, height: 120)
		})
		return row
	}
	
	private func makeViewModel(ID: Int? = nil) -> AutoLayoutCollectionViewCellModel {
		let fNames = ["Иван","Сергей", "Николай", "Валентин", "Александр", "Семн", "Виктор", "Эдуард"]
		return AutoLayoutCollectionViewCellModel(ID: ID ?? Int.random(in: 0..<Int.max), title1: fNames.randomValue(), title2: fNames.randomValue())
	}
	
	private func  makeAlert() {
		let action = UIAlertAction(title: "OK", style: .default) { (_) in }
		let controller = UIAlertController(title: "Внимание", message: "Произошло событие определенное пользователем", preferredStyle: .alert)
		controller.addAction(action)
		self.present(controller, animated: true) {}
	}
}

fileprivate extension Array {
	func randomValue() -> Element {
		return self[Int.random(in: 0..<self.count)]
	}
	
	
}
