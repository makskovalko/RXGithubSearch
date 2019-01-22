//
//  Request.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/18/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import Foundation

protocol Request {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: RequestParams { get }
    var headers: [String: Any]? { get }
    var dataType: DataType { get }
}

enum DataType {
    case json
    case data
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum RequestParams {
    typealias Parameters = [String: Any]
    
    case body(_: Parameters)
    case url(_: Parameters)
}

extension Request {
    private var absoluteUrl: String {
        return baseURL.absoluteString + path
    }
}

//MARK: - Generate URLRequest

extension Request {
    var urlRequest: URLRequest {
        guard let url = URL(string: absoluteUrl) else { fatalError() }
        var request = URLRequest(url: url)
        
        switch parameters {
        case .body(let params):
            request.httpBody = try? JSONSerialization.data(
                withJSONObject: params,
                options: .prettyPrinted
            )
        case .url(let params):
            let queryParams = params.map { item -> URLQueryItem in
                return URLQueryItem(
                    name: item.key,
                    value: .init(describing: item.value)
                )
            }
            
            guard var components = URLComponents(string: absoluteUrl) else { fatalError() }
            
            components.queryItems = queryParams
            request.url = components.url
        }
        
        headers?.forEach {
            request.setValue(
                .init(describing: $0.value),
                forHTTPHeaderField: $0.key
            )
        }
        
        return request
    }
}
