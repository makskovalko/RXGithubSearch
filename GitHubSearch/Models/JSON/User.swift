//
//  User.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/18/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import ObjectMapper

struct User: ImmutableMappable {
    let id: Int
    let name: String
    let login: String
    let email: String
    let url: String?
    let avatarUrl: String?
    
    init(with object: Any) {
        self = try! Mapper<User>().map(JSONObject: object)
    }
    
    init(map: Map) throws {
        id = try! map.value("id")
        name = try! map.value("name")
        login = try! map.value("login")
        email = try! map.value("email")
        url = try? map.value("url")
        avatarUrl = try? map.value("avatar_url")
    }
    
    func mapping(map: Map) {
        id >>> map["id"]
        name >>> map["name"]
        login >>> map["login"]
        email >>> map["email"]
        url >>> map["url"]
        avatarUrl >>> map["avatarUrl"]
    }
}
