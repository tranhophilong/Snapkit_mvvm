//
//  ObservableObject.swift
//  DemoSnapkit
//
//  Created by Long Tran on 03/10/2023.
//

import Foundation


final class ObservableObject<T>{
    var value : T{
        didSet{
            self.listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener : @escaping (T) -> Void){
        listener(value)
        self.listener = listener
    }
}
