//
//  Optional+Extension.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/18/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

//MARK: - Applicative

extension Optional {
    func apply<Result>(_ transform: ((Wrapped) -> Result)?) -> Result? {
        return flatMap { value in
            transform.map { $0(value) }
        }
    }
    
    func apply<Value, Result>(_ value: Value?) -> Result? where Wrapped == (Value) -> Result {
        return flatMap { value.map($0) }
    }
    
    func flatten<Result>() -> Result? where Wrapped == Result? {
        return flatMap { $0 }
    }
    
    func `do`(_ action: (Wrapped) -> Void) {
        self.map(action)
    }
}
