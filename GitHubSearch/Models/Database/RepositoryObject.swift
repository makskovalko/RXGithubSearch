//
//  RepositoryModel.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/21/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import RealmSwift

class RepositoryObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var descriptionInfo: String? = nil
    @objc dynamic var url: String = ""
    @objc dynamic var starsCount: Int = 0
    
    convenience init(repository: Repository) {
        self.init()
        id = repository.id
        name = repository.name
        descriptionInfo = repository.description
        url = repository.url
        starsCount = repository.starsCount
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
