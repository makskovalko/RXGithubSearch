//
//  SearchService.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/20/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import RxSwift
import ObjectMapper
import RealmSwift

protocol SearchOperations {
    var paginator: Paginator<Repository> { get }
    init(paginator: Paginator<Repository>)
    
    func performRequest(query: String, completion: @escaping (Result<[Repository], Error>) -> ())
}

final class SearchService: SearchOperations {
    let disposeBag = DisposeBag()
    var paginator: Paginator<Repository>
    
    private var isNetworkAvailable: Bool {
        return ReachabilityManager.shared.isNetworkAvailable
    }
    
    required init(paginator: Paginator<Repository>) {
        self.paginator = paginator
    }
}

//MARK: - Execute Search

extension SearchService {
    func performRequest(query: String, completion: @escaping (Result<[Repository], Error>) -> ()) {
        let requests = (0 ..< paginator.requestsCount).enumerated().map {
            return request(
                query: query,
                page: paginator.page + $0.offset,
                perPage: paginator.perPage,
                onScheduler: ConcurrentDispatchQueueScheduler(qos: .background)
            )
        }
        
        let fetchRemoteRepositories = Observable.combineLatest(requests)
            .flatMapLatest { (repositories: [[Repository]]) -> Observable<[Repository]> in
                Observable.of(repositories.flatMap { $0 })
        }
        
        let observableDataSource = isNetworkAvailable
            ? fetchRemoteRepositories
            : fetchRepositoriesFromDatabase(query: query)
        
        
        observableDataSource
            .observeOn(MainScheduler.instance).do { [unowned self] in
                self.paginator.loadMore = false
            }.subscribe(onNext: { [unowned self] in
                self.paginator.dataSource.append(contentsOf: $0)
                self.isNetworkAvailable => self.saveToDatabase()
                completion(.success(self.paginator.dataSource))
                }, onError: { completion(.failure($0))
            }).disposed(by: disposeBag)
    }
}

//MARK: - Fetch Repositories

private extension SearchService {
    func request(query: String,
                 page: Int,
                 perPage: Int,
                 onScheduler scheduler: ImmediateSchedulerType) -> Observable<[Repository]> {
        return URLSession.shared.rx.json(
            request: GithubRequest.repositories(
                name: query,
                page: page,
                perPage: perPage).urlRequest)
            .map { json -> [Repository] in
                guard let json: JSON = cast(json),
                    let items: [JSON] = cast(json["items"]) else { return [] }
                return try Mapper<Repository>().mapArray(JSONArray: items)
            }.subscribeOn(scheduler)
    }
}

//MARK: - Database Operations

private extension SearchService {
    func saveToDatabase() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(paginator.dataSource.map(RepositoryObject.init), update: true)
        }
    }
    
    func fetchRepositoriesFromDatabase(query: String) -> Observable<[Repository]> {
        let realm = try! Realm()
        
        let repositories = realm.objects(RepositoryObject.self)
            .filter { $0.name.lowercased().contains(query.lowercased()) }
        
        return Observable.of(repositories.map(Repository.init))
    }
}
