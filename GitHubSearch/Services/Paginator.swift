//
//  Paginator.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/20/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import Foundation

protocol Pagination {
    associatedtype DataSource
    
    var page: Int { get set }
    var perPage: Int { get set }
    var loadMore: Bool { get set }
    var requestsCount: Int { get set }
    
    var dataSource: [DataSource] { get set }
    
    init(page: Int, perPage: Int, requestsCount: Int)
    
    func next(callback: @escaping () -> ())
    func loadMore(callback: @escaping () -> ())
    func reset()
}

final class Paginator<T>: Pagination {
    var page: Int
    var perPage: Int
    var loadMore = false
    var requestsCount = 2
    
    var dataSource: [T] = []
    
    init(page: Int, perPage: Int, requestsCount: Int) {
        self.page = page
        self.perPage = perPage
        self.requestsCount = requestsCount
    }
    
    func next(callback: @escaping () -> ()) {
        page += requestsCount
        loadMore = true
        callback()
    }
    
    func loadMore(callback: @escaping () -> ()) {
        callback()
    }
    
    func reset() {
        loadMore = false
        page = 1
        dataSource = []
    }
}
