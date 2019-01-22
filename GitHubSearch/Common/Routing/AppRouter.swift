//
//  AppDouter.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/21/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import ObjectMapper

final class AppRouter {
    func setupInitialFlow() -> UIWindow? {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: initialViewController)
        window.makeKeyAndVisible()
        return window
    }
    
    var initialViewController: UIViewController {
        guard UserDefaults.standard.object(forKey: .credentials) != nil else {
            return authorizationViewController
        }
        return searchViewController
    }
    
    private var authorizationViewController: UIViewController {
        let authViewController = AuthorizationViewController()
        AuthorizationModuleConfigurator().configureModuleForViewInput(viewInput: authViewController)
        return authViewController
    }
    
    private var searchViewController: UIViewController {
        let searchViewController = SearchViewController()
        SearchModuleConfigurator().configureModuleForViewInput(viewInput: searchViewController)
        return searchViewController
    }
}

