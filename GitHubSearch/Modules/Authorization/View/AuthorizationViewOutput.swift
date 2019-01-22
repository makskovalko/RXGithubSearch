//
//  AuthorizationAuthorizationViewOutput.swift
//  GitHubSearch
//
//  Created by Maksim Kovalko (Kharkiv) on 18/06/2018.
//  Copyright © 2018 Maksym Kovalko. All rights reserved.
//

protocol AuthorizationViewOutput {

    /**
        @author Maksim Kovalko (Kharkiv)
        Notify presenter that view is ready
    */

    func viewIsReady()
    
    func logIn(userName: String, password: String)
}
