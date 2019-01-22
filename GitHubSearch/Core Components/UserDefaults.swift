//
//  UserDefaults.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/18/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import Foundation

extension UserDefaults {
    func object<T>(for key: String) -> T? {
        return UserDefaults.standard.object(forKey: key) |> cast
    }
    
    func removeObject(by key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func add<T>(_ object: T?, forKey key: String) {
        UserDefaults.standard.setValue(object, forKey: key)
    }
}
