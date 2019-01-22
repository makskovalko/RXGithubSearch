//
//  AuthorizationService.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/18/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import RxSwift

protocol Authorization: class {
    func logIn(userName: String, password: String) throws -> Observable<User>
}

final class AuthorizationService: Authorization {
    func logIn(userName: String, password: String) throws -> Observable<User> {
        let request = GithubRequest.logIn(
            userName: userName,
            password: password
        )
        return URLSession.shared
            .rx.json(request: request.urlRequest)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .do(onNext: { _ in
                UserDefaults.standard.add(
                    request.headers,
                    forKey: .authorizationKey
                )
            }).map(User.init)
            .observeOn(MainScheduler.instance)
    }
}
