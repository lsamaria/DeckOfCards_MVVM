//
//  ObserverObject.swift
//  MVVM
//
//  Created by LanceMacBookPro on 11/3/22.
//

import Foundation

final class ObserverableObject<T> {
    
    typealias Listener = (T)->Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(callback: Listener?) {
        listener = callback
        callback?(value)
    }
}
