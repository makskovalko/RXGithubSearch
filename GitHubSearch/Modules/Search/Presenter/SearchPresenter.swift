//
//  SearchSearchPresenter.swift
//  GitHubSearch
//
//  Created by Maksim Kovalko (Kharkiv) on 18/06/2018.
//  Copyright © 2018 Maksym Kovalko. All rights reserved.
//

struct RepositoryViewModel {
    let title: String
    let description: String
    let url: String
}

class SearchPresenter: SearchModuleInput, SearchViewOutput, SearchInteractorOutput {
    weak var view: SearchViewInput!
    var interactor: SearchInteractorInput!
    var router: SearchRouterInput!
    
    var repositories: [Repository] = []
    var viewModels: [RepositoryViewModel] = [] { didSet { view.updateUIState() } }
    
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func performSearch(query: String) {
        interactor.performSearch(query: query)
    }
    
    func loadNextPage(query: String) {
        interactor.loadNextPage(query: query)
    }
    
    func loadFromBeginning(query: String) {
        interactor.loadFromBeginning(query: query)
    }
    
    func resetPagination() {
        interactor.resetPagination()
    }
    
    func didFetchRepositories(_ repositories: [Repository]) {
        self.repositories = repositories
        
        viewModels = repositoriesViewModels(
            from: repositories,
            maxStrLenght: 30
        )
    }
}

//MARK: - Generate View Models

extension SearchPresenter {
    func repositoriesViewModels(from models: [Repository],
                                maxStrLenght: Int) -> [RepositoryViewModel] {
        return models.compactMap {
            let title = "\($0.name[0 ..< maxStrLenght]) (\($0.starsCount) ★)"
            let description = $0.description ?? ""
            
            return RepositoryViewModel(
                title: title,
                description: description.count < maxStrLenght
                    ? description
                    : description[0 ..< maxStrLenght] + "...",
                url: $0.url
            )
        }
    }
}
