//
//  AuthorizationAuthorizationInteractor.swift
//  GitHubSearch
//
//  Created by Maksim Kovalko (Kharkiv) on 18/06/2018.
//  Copyright © 2018 Maksym Kovalko. All rights reserved.
//

import RxSwift

class AuthorizationInteractor: AuthorizationInteractorInput {
    weak var output: AuthorizationInteractorOutput!
    
    var authorizationService: Authorization!
    let disposeBag = DisposeBag()
    
    func logIn(userName: String, password: String) {
        try? authorizationService.logIn(
            userName: userName,
            password: password
        ).observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.cacheUser($0)
                self?.output.didLogin(with: $0)
            }, onError: { [weak self] in
                self?.output.didFetchError($0)
            }).disposed(by: disposeBag)
    }
    
    private func cacheUser(_ user: User) {
        UserDefaults.standard.add(user.toJSON(), forKey: .credentials)
    }
}
