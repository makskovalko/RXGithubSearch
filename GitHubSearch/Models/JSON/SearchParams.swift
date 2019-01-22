//
//  SearchParams.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/20/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import ObjectMapper

enum Order: String {
    case asc
    case desc
}

struct SearchParams: ImmutableMappable {
    let query: String
    let page: Int
    let perPage: Int
    let sort: String
    let order: String
    
    init(query: String,
         page: Int,
         perPage: Int,
         sort: String,
         order: String) {
        self.query = query
        self.page = page
        self.perPage = perPage
        self.sort = sort
        self.order = order
    }
    
    init(map: Map) throws {
        query = (try? map.value("q")) ?? ""
        page = (try? map.value("page")) ?? 1
        perPage = (try? map.value("per_page")) ?? 30
        sort = (try? map.value("sort")) ?? ""
        order = (try? map.value("order")) ?? ""
    }
    
    func mapping(map: Map) {
        query >>> map["q"]
        page >>> map["page"]
        perPage >>> map["per_page"]
        sort >>> map["sort"]
        order >>> map["order"]
    }
}
