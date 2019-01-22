//
//  Endpoints.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/18/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import Foundation

extension String {
    static let authorizationKey = "Authorization"
    static let credentials = "Credentials"
}

enum GithubRequest: Request {
    case logIn(userName: String, password: String)
    case repositories(name: String, page: Int, perPage: Int)
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .logIn:
            return "/user"
        case .repositories:
            return "/search/repositories"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .logIn, .repositories:
            return .get
        }
    }
    
    var headers: [String: Any]? {
        switch self {
        case let .logIn(userName, password):
            let loginString = "\(userName):\(password)"
            
            guard let loginData = loginString
                .data(using: .utf8)?
                .base64EncodedString() else { return [:] }
            
            return [.authorizationKey: "Basic \(loginData)"]
        case .repositories:
            return UserDefaults
                .standard
                .object(for: .authorizationKey) ?? [:]
        }
    }
    
    var dataType: DataType { return .json }
    
    var parameters: RequestParams {
        switch self {
        case .logIn:
            return .url([:])
        case let .repositories(name, page, perPage):
            return .url(
                SearchParams(
                    query: name,
                    page: page,
                    perPage: perPage,
                    sort: "stars",
                    order: Order.desc.rawValue
                ).toJSON()
            )
        }
    }
}
