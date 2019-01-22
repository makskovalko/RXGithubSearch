//
//  AuthorizationAuthorizationConfigurator.swift
//  GitHubSearch
//
//  Created by Maksim Kovalko (Kharkiv) on 18/06/2018.
//  Copyright © 2018 Maksym Kovalko. All rights reserved.
//

import UIKit

class AuthorizationModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? AuthorizationViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: AuthorizationViewController) {

        let router = AuthorizationRouter()

        let presenter = AuthorizationPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = AuthorizationInteractor()
        interactor.output = presenter
        interactor.authorizationService = AuthorizationService()

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
