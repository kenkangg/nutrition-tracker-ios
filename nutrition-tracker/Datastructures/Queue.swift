//
//  Queue.swift
//  nutrition-tracker
//
//  Created by Kenny Kang on 10/18/17.
//  Copyright © 2017 Kenny Kang. All rights reserved.
//

import Foundation

public struct Queue<T> {

    fileprivate var list = LinkedList<T>()
    
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    public mutating func dequeue() -> T? {
        
        guard !list.isEmpty, let element = list.first else { return nil }
        
        _ = list.remove(element)
        
        return element.value
    }
    
    public func peek() -> T? {
        return list.first?.value
    }
}
