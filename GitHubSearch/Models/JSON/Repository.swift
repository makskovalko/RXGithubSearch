//
//  Repository.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/18/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import ObjectMapper

struct Repository: ImmutableMappable {
    let id: Int
    let name: String
    let description: String?
    let url: String
    let starsCount: Int
    
    init(model: RepositoryObject) {
        id = model.id
        name = model.name
        description = model.descriptionInfo
        url = model.url
        starsCount = model.starsCount
    }
    
    init(map: Map) throws {
        id = try! map.value("id")
        name = try! map.value("name")
        description = try? map.value("description")
        url = try! map.value("html_url")
        starsCount = (try? map.value("stargazers_count")) ?? 0
    }
    
    func mapping(map: Map) {
        id >>> map["id"]
        name >>> map["name"]
        description >>> map["description"]
        url >>> map["html_url"]
        starsCount >>> map["stargazers_count"]
    }
}
