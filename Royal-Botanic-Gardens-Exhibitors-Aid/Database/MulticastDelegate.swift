//
//  MulticastDelegate.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 2/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import Foundation

class MulticastDelegate <T> {
    private var delegates = Set<WeakObjectWrapper> ()
    
    func addDelegate(_ delegate: T) { // i can send any object of that class
        let delegateObject = delegate as AnyObject
        delegates.insert(WeakObjectWrapper(value: delegateObject))
    }
    
    func removeDelegate(_ delegate: T) {
        let delegateObject = delegate as AnyObject
        delegates.remove(WeakObjectWrapper(value: delegateObject))
    }
    
    func invoke(invocation: (T) -> ()) {
        delegates.forEach { (delegateWrapper) in
            if let delegate = delegateWrapper.value {
                invocation(delegate as! T)
            }
        }
    }
}

private class WeakObjectWrapper: Equatable, Hashable {
    
    
    weak var value: AnyObject?
    
    init(value: AnyObject) {
        self.value = value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(value!).hashValue)
    }
    
    static func == (lhs: WeakObjectWrapper, rhs: WeakObjectWrapper) -> Bool {
        return lhs.value === rhs.value
    }
}
