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
