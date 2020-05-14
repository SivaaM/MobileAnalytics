//
//  Observable.swift
//  TableViewMVVM
//
//  Created by Fahath Rajak on 10/27/19.
//  Copyright © 2019 Fahath. All rights reserved.
//

import Foundation

class Observable<T> {
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
            }
        }
    }
    
    typealias ValueChanged = (T) -> Void
    
    private var valueChanged: ValueChanged?
    
    init(value: T) {
        self.value = value
    }
    
    func addObserver(fireNow: Bool = true, onChange: ValueChanged?) {
        valueChanged = onChange
        if fireNow {
            onChange?(value)
        }
    }
    
    func removeObserver() {
        valueChanged = nil
    }
    
}
