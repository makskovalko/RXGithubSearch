//
//  SearchSearchInteractorOutput.swift
//  GitHubSearch
//
//  Created by Maksim Kovalko (Kharkiv) on 18/06/2018.
//  Copyright © 2018 Maksym Kovalko. All rights reserved.
//

import Foundation

protocol SearchInteractorOutput: class {
    func didFetchRepositories(_ repositories: [Repository])
}
