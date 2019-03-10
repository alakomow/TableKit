//
//  ThreadSafeArray.swift
//  TableKit
//
//  Created by Лакомов А.Ю. on 27/02/2019.
//  Copyright © 2019 Tensor. All rights reserved.
//

/// Потокобезопасный класс для массивов. Все свойства и методы являются обертками над стандартными значениями массивов из swift
import Foundation

final public class SafeArray<Element> {
	
	public typealias ArrayType = [Element]
	public var elementsDidSetBlock: (() -> Void)?
	
	private let queue: DispatchQueue
	private var elements: ArrayType { didSet {
		DispatchQueue.main.async {
			self.elementsDidSetBlock?()
		}
	}}
	
	init(_ elements: ArrayType = []) {
		self.queue = DispatchQueue(label: "SafeArray<\(Element.self)>", qos: .userInteractive, attributes: .concurrent)
		self.elements = elements
	}
}
// MARK: - Свойства (property) -
public extension SafeArray {
	public var isEmpty: Bool { return threadSafeElements().isEmpty }
	public var count: Int { return threadSafeElements().count }
	public var first: Element? { return threadSafeElements().first }
	public var description: String { return self.threadSafeElements().description }
	public var debugDescription: String { return self.threadSafeElements().debugDescription }
	public var allValues: [Element] { return threadSafeElements() }
}
// MARK: - Методы изменения данных -
public extension SafeArray {
	
	public func append(element: Element) {
		appent(elements: [element])
	}
	
	public func appent(elements: ArrayType) {
		async { self.elements.append(contentsOf: elements) }
	}
	
	public func insert(_ element: Element, at i: Int) {
		insert([element], at: i)
	}
	
	public func insert(_ elements: ArrayType, at i: Int) {
		async { self.elements.insert(contentsOf: elements, at: i) }
	}
	
	public func replace(at index: Int, with elemnt: Element) {
		async {
			if self.elements.indices.contains(index) {
				self.elements[index] = elemnt
			}
		}
	}
	
	public func swap(from: Int, to: Int) {
		async { self.elements.swapAt(from, to) }
	}
	
	public func remove(elementAt index: Int) {
		async { self.elements.remove(at: index) }
	}
	
	public func removeAll() {
		async { self.elements.removeAll() }
	}
}

// MARK: - Внутренние вспомогательные методы -
private extension SafeArray {

	private func threadSafeElements() -> ArrayType {
		var result: [Element] = []
		self.queue.sync { result = self.elements }
		return result
	}
	
	/// Используется для изменения елементов в массиве. Пареметр barrier нужен для потокабезопастного изменения данных.
	///
	/// - Parameter block: действие которое необходимо выполнить с данными массива.
	private func async(_ block: @escaping () -> Void) {
		self.queue.async(flags: .barrier) {
			block()
		}
	}
}
// MARK: - Поддержка возможности работы с обьектом как с обычным массивом swift -
extension SafeArray: Sequence {
	public subscript (position: ArrayType.Index) -> Element { return threadSafeElements()[position] }
	public subscript (safe index: ArrayType.Index) -> Element? {
		let elements = self.threadSafeElements()
		guard index >= 0 && index < elements.count else { return nil }
		return elements[index]
	}
	
	public func makeIterator() -> IndexingIterator<ArrayType> { return threadSafeElements().makeIterator() }
}



///// For test
//
//  CellManagment.swift
//  TestUISequence
//
//  Created by Лакомов А.Ю. on 14/02/2019.
//  Copyright © 2019 Лакомов А.Ю. All rights reserved.
//

import TableKit

protocol MyCellSbisTable {
	static var identifier: String { get }
}

extension MyCellSbisTable {
	static var identifier: String {
		return String(describing: self)
	}
}

class MyCell1: UITableViewCell, ConfigurableCell {
	
	enum MyCell1CustomActions: String {
		case buttonClick
		case userPhotoTap
	}
	
	@IBOutlet weak var label1: UILabel!
	@IBOutlet weak var label2: UILabel!
	
	var indexPath: IndexPath?
	weak var customCellActionDelegate: ConfigurableCellDelegate?
	
	func configure(with model: MyViewModel1) {
		label1.text = model.fName
		label2.textColor = UIColor.purple
		label2.text = model.lName
		label2.textColor = UIColor.purple
		backgroundColor = model.bgColor
	}
	
	@IBAction func myButtonClicked(sender: UIButton?) {
		customCellActionDelegate?.customAction(cell: self, actionString: MyCell1CustomActions.buttonClick.rawValue)
	}
	
	@IBAction func userPhotoClicked(sender: UIButton?) {
		customCellActionDelegate?.customAction(cell: self, actionString: MyCell1CustomActions.userPhotoTap.rawValue)
	}
}

class MyCell2: UITableViewCell, ConfigurableCell {
	
	static let DeleteButtonClick = "DeleteButtonClick"
	
	@IBOutlet weak var label1: UILabel!
	
	var indexPath: IndexPath?
	weak var customCellActionDelegate: ConfigurableCellDelegate?
	
	@IBAction func buttonClick(_ sender: Any) {
		customCellActionDelegate?.customAction(cell: self, actionString: MyCell2.DeleteButtonClick)
	}
	func configure(with model: MyViewModel2) {
		label1.text = model.fio
		label1.textColor = UIColor.purple
		backgroundColor = model.bgColor
	}
}

extension UIColor {
	static var randomColor: UIColor {
		let range = (0..<255).map{ return CGFloat($0) }
		return UIColor(displayP3Red: range.randomValue()/255, green: range.randomValue()/255, blue: range.randomValue()/255, alpha: 1.0)
	}
}

struct MyViewModel1: ConfigurableViewModel, AdditionalDebugInfo {
	func customDebugDescription() -> String {
		return "\(self); ID:\(ID); fName:\(fName); lName:\(lName);"
	}
	
	var identifier: Int { return ID }
	
	let ID: Int
	let fName: String
	let lName: String
	let bgColor = UIColor.randomColor.withAlphaComponent(0.5)
	
	func hasDifferences(with model: MyViewModel1) -> Bool {
		return !(fName == model.fName && lName == model.lName)
	}
}

struct MyViewModel2: ConfigurableViewModel, AdditionalDebugInfo {
	func customDebugDescription() -> String {
		return "\(self); ID: \(ID); FIO:'\(fio)'"
	}
	
	var identifier: Int {
		return ID
	}
	let ID: Int
	let fio: String
	let bgColor = UIColor.randomColor.withAlphaComponent(0.5)
	
	func hasDifferences(with model: MyViewModel2) -> Bool {
		return fio != model.fio
	}
}



class MyPresenter {
	let tableDirector: TableManager<UITableView>
	private let data: [MyViewModel1]
	private let dataGenerator = DataGenerator()
	
	init(table: UITableView) {
		self.tableDirector = TableManager(sheet: table)
		self.data = DataGenerator().makePersons(count: 2)
	}
	
	func start() {
		let section: TableSection
		if let s = tableDirector.sections.first {
			section = s
		} else {
			section = TableSection()
			tableDirector.append(section: section)
		}
		
		section.rows.removeAll()
		var rows: [Row] = []
		data.forEach {
			
			rows.append(TableRow<MyCell1>(item: $0)
				.on(.click { (option) in
					var rows = [Row]()
					rows.append(TableRow<MyCell2>(item: self.dataGenerator.makeFIO())
						.on(.custom(MyCell2.DeleteButtonClick) { (options) in
							let indexPath = options.indexPath
							
							section.remove(rowAt: indexPath.row)
							})
					)
					section.append(rows: rows)
					})
				.on(.height { (options) in
					return 150
					})
				.on(.custom(MyCell1.MyCell1CustomActions.buttonClick.rawValue) { (options) in
					print("")
					})
				.on(.custom(MyCell1.MyCell1CustomActions.userPhotoTap.rawValue) { (options) in
					let x = ""
					print(x)
					})
			)
		}
		section.append(rows: rows)
		
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			//			self.start()
		}
	}
}


fileprivate class DataGenerator {
	private let fNames = ["Иван","Сергей", "Николай", "Валентин", "Александр", "Семн", "Виктор", "Эдуард"]
	private let lNames = ["Иванов", "Сергеев", "Александров","Андропов", "Петров", "Никулин", "Пушкин"]
	private let mNames = ["Сергеевич", "Викторович","Юрьевич", "Александрович", "Петрович", "Николаевич"]
	
	func makeFIO() -> MyViewModel2 {
		let fio = fNames.randomValue() + " " + lNames.randomValue() + " " + mNames.randomValue()
		return MyViewModel2(ID: Int.random(in: 0..<Int.max), fio: fio)
	}
	
	func makePerson(ID: Int) -> MyViewModel1 {
		return MyViewModel1(ID: ID, fName: fNames.randomValue(), lName: lNames.randomValue())
	}
	
	func makePersons(count: Int) -> [MyViewModel1] {
		return (0..<count).map { (index) -> MyViewModel1 in
			return self.makePerson(ID: index)
		}
	}
	
}

fileprivate extension Array {
	func randomValue() -> Element {
		return self[Int.random(in: 0..<self.count)]
	}
}

