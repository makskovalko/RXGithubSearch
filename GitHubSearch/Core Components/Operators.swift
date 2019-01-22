//
//  Operators.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/18/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

precedencegroup ConditionPrecedence {
    associativity: right
    lowerThan: ComparisonPrecedence
}

infix operator =>: ConditionPrecedence

func => (condition: Bool, execute: @autoclosure () -> ()) {
    guard condition else { return }
    execute()
}

// Operator for chaining calls in reverse order
precedencegroup CompositionPrecedence {
    associativity: left
}
infix operator |>: CompositionPrecedence

/// Connect two calls into one.
public func |> <T, U, V> (from: @escaping (T) throws -> U, to: @escaping ((U) throws -> V)) -> (((T) throws -> V)) {
    return { t in
        let u = try from(t)
        return try to(u)
    }
}

/// Apply argument to call.
public func |> <T, U> (from: T, to: (T) throws -> U) rethrows -> U {
    return try to(from)
}

/// Connect two calls into one.
public func |> <T, U, V> (from: @escaping (T) -> U, to: @escaping (U) -> V) -> ((T) -> V) {
    return { to(from($0)) }
}

func cast<T>(_ value: Any?) -> T? {
    return value as? T
}
