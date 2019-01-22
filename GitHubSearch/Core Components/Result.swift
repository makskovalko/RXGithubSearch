//
//  Result.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/21/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

enum Result<Value, Error> {
    case success(Value)
    case failure(Error)
}

//MARK: - Functor

extension Result {
    func map<A>(_ transform: (Value) -> A) -> Result<A, Error> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }
}

//MARK: - Monad

extension Result {
    func flatMap<A>(_ transform: (Value) -> Result<A, Error>) -> Result<A, Error> {
        switch self {
        case .success(let value):
            return transform(value)
        case .failure(let error):
            return .failure(error)
        }
    }
}
