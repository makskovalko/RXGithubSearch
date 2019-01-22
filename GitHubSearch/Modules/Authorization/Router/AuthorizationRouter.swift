//
//  AuthorizationAuthorizationRouter.swift
//  GitHubSearch
//
//  Created by Maksim Kovalko (Kharkiv) on 18/06/2018.
//  Copyright © 2018 Maksym Kovalko. All rights reserved.
//

class AuthorizationRouter: AuthorizationRouterInput {
    
    func openSearch(context: AuthorizationViewInput) {
        let searchViewController = SearchViewController()
        SearchModuleConfigurator().configureModuleForViewInput(viewInput: searchViewController)
        
        let authViewController: AuthorizationViewController? = cast(context)
        authViewController.do {
            $0.navigationController?.pushViewController(
                searchViewController,
                animated: true
            )
        }
    }
    
}
