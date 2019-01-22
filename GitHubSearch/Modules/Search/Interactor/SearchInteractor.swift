//
//  SearchSearchInteractor.swift
//  GitHubSearch
//
//  Created by Maksim Kovalko (Kharkiv) on 18/06/2018.
//  Copyright © 2018 Maksym Kovalko. All rights reserved.
//

class SearchInteractor: SearchInteractorInput {

    weak var output: SearchInteractorOutput!
    
    var searchService: SearchOperations!
    
    private var shouldLoadMore: Bool {
        return searchService.paginator.loadMore
    }

    func performSearch(query: String) {
        searchService.performRequest(query: query) { [weak self] in
            switch $0 {
            case .success(let repositories):
                self?.output.didFetchRepositories(repositories)
            case .failure:
                self?.output.didFetchRepositories([])
            }
        }
    }
    
    func resetPagination() {
        searchService.paginator.reset()
    }
    
    func loadNextPage(query: String) {
        guard !shouldLoadMore else { return }
        
        searchService.paginator.next { [weak self] in
            self?.performSearch(query: query)
        }
    }
    
    func loadFromBeginning(query: String) {
        searchService.paginator.loadMore { [weak self] in
            self?.performSearch(query: query)
        }
    }
}
