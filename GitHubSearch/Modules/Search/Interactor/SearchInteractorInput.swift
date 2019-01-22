//
//  SearchSearchInteractorInput.swift
//  GitHubSearch
//
//  Created by Maksim Kovalko (Kharkiv) on 18/06/2018.
//  Copyright © 2018 Maksym Kovalko. All rights reserved.
//

import Foundation

protocol SearchInteractorInput {
    func performSearch(query: String)
    func resetPagination()
    func loadNextPage(query: String)
    func loadFromBeginning(query: String)
}
