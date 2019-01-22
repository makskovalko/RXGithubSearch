//
//  AuthorizationAuthorizationInteractorOutput.swift
//  GitHubSearch
//
//  Created by Maksim Kovalko (Kharkiv) on 18/06/2018.
//  Copyright © 2018 Maksym Kovalko. All rights reserved.
//

import Foundation

protocol AuthorizationInteractorOutput: class {
    func didLogin(with user: User)
    func didFetchError(_ error: Error)
}
