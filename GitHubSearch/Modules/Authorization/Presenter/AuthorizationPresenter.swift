//
//  AuthorizationAuthorizationPresenter.swift
//  GitHubSearch
//
//  Created by Maksim Kovalko (Kharkiv) on 18/06/2018.
//  Copyright © 2018 Maksym Kovalko. All rights reserved.
//

class AuthorizationPresenter: AuthorizationModuleInput,
                              AuthorizationViewOutput,
                              AuthorizationInteractorOutput {

    weak var view: AuthorizationViewInput!
    var interactor: AuthorizationInteractorInput!
    var router: AuthorizationRouterInput!

    func viewIsReady() {
        view.setupInitialState()
    }
    
    func logIn(userName: String, password: String) {
        interactor.logIn(userName: userName, password: password)
    }
    
    func didLogin(with user: User) {
        router.openSearch(context: view)
    }
    
    func didFetchError(_ error: Error) {
        view.showError(error)
    }
}
