//
//  AuthorizationAuthorizationViewInput.swift
//  GitHubSearch
//
//  Created by Maksim Kovalko (Kharkiv) on 18/06/2018.
//  Copyright © 2018 Maksym Kovalko. All rights reserved.
//

protocol AuthorizationViewInput: class {

    /**
        @author Maksim Kovalko (Kharkiv)
        Setup initial state of the view
    */

    func setupInitialState()
    func showError(_ error: Error)
}
