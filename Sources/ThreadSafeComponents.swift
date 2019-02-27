//
//  ThreadSafeArray.swift
//  TableKit
//
//  Created by Лакомов А.Ю. on 27/02/2019.
//  Copyright © 2019 Max Sokolov. All rights reserved.
//


protocol ThreadSafeArray {
	associatedtype Element
	var isEmpty: Bool { get }
	var elementsCount: Bool { get }
	
	func removeAllElements()
	func append(element: Element)
	func appent(elementa: [Element])
	func insert(_ element: Element, at index: Int)
	func insert(_ elements: [Element], at index: Int)
	func replace(elementAt index: Int, with elemnt: Element)
	func swap(from: Int, to: Int)
	func remove(elementAt index: Int)
	
}
