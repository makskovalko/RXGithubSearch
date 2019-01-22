//
//  SearchSearchViewController.swift
//  GitHubSearch
//
//  Created by Maksim Kovalko (Kharkiv) on 18/06/2018.
//  Copyright © 2018 Maksym Kovalko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper

class SearchViewController: UIViewController, SearchViewInput {

    var output: SearchViewOutput!
    
    let disposeBag = DisposeBag()
    
    lazy var tableView = createTableView()
    lazy var searchBar = createSearchBar()
    lazy var tableViewSpinner = createTableViewSpinner(for: tableView)
    lazy var overlayView = createOverlayView()
    lazy var opacityView = createOverlayView()
    
    var searchText: String { return searchBar.text ?? "" }
    
    init() { super.init(nibName: nil, bundle: nil) }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
        initViews()
        
        navigationItem.hidesBackButton = true
    }
    
    // MARK: SearchViewInput
    
    func setupInitialState() {
        /* Subscriptions */do {
            [searchBarSubscribe,
             willDisplayCellSubscribe,
             didScrollSubscribe
            ].forEach { $0() }
        }
    }
    
    func updateUIState() {
        tableView.reloadData()
        tableViewSpinner.isHidden = true
    }
}

//MARK: - Setup Subscribers

private extension SearchViewController {
    func searchBarSubscribe() {
        searchBar.rx
            .text.orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in onSearchBarValueChanged() }
        ).disposed(by: disposeBag)
        
        func onSearchBarValueChanged() {
            output.resetPagination()
            updateUIState()
            output.loadFromBeginning(query: searchText)
        }
    }
    
    func willDisplayCellSubscribe() {
        tableView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] in
                let (_, indexPath) = $0
                self?.willDisplayCell(for: indexPath)
            }).disposed(by: disposeBag)
    }
    
    func didScrollSubscribe() {
        tableView.rx.didScroll
            .subscribe(onNext: { [weak self] in
                self?.didScroll()
            }).disposed(by: disposeBag)
    }
    
    private func willDisplayCell(for indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            tableView.tableFooterView = tableViewSpinner
            tableView.tableFooterView?.isHidden = false
        }
    }
    
    private func didScroll() {
        let (height, contentYoffset) = (
            tableView.frame.size.height,
            tableView.contentOffset.y
        )
        let distanceFromBottom = tableView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            output.loadNextPage(query: searchText)
        }
    }
}

//MARK: - Create Views

private extension SearchViewController {
    func createTableView() -> UITableView {
        let configure = {
            $0.dataSource = self
            $0.delegate = self
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.keyboardDismissMode = .onDrag
            $0.register(
                UITableViewCell.self,
                forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self)
            )
        } as  (UITableView) -> Void
        
        let tableView = UITableView()
        configure(tableView)
        return tableView
    }
    
    func createSearchBar() -> UISearchBar {
        let configure = {
            $0.searchBarStyle = UISearchBarStyle.minimal
            $0.placeholder = " Search..."
            $0.sizeToFit()
            $0.isTranslucent = false
            $0.backgroundImage = UIImage()
        } as (UISearchBar) -> Void
       
        let searchBar = UISearchBar()
        configure(searchBar)
        return searchBar
    }
    
    func createTableViewSpinner(for tableView: UITableView) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        spinner.startAnimating()
        spinner.frame = CGRect(
            x: CGFloat(0),
            y: CGFloat(0),
            width: tableView.bounds.width,
            height: CGFloat(44)
        )
        
        return spinner
    }
    
    func createOverlayView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        return view
    }
}

//MARK: - Init Views

private let padding: CGFloat = 20
private let webViewHeight: CGFloat = 150

private extension SearchViewController {
    func initViews() {
        initTableView()
        initOpacityView()
        initOverlayView()
        
        navigationItem.titleView = searchBar
        
        overlayView.isHidden = true
        opacityView.isHidden = true
    }

    private func initTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.alLeading == view.alLeading,
            tableView.alTrailing == view.alTrailing,
            tableView.alTop == view.alTop,
            tableView.alBottom == view.alBottom
        ])
    }
    
    private func initOverlayView() {
        opacityView.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.alLeading == view.alLeading + padding,
            overlayView.alTrailing == view.alTrailing - padding,
            overlayView.alCenterX == view.alCenterX,
            overlayView.alCenterY == view.alCenterY,
            overlayView.alHeight == view.alHeight - webViewHeight
        ])
    }
    
    private func initOpacityView() {
        opacityView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.addSubview(opacityView)
        
        NSLayoutConstraint.activate([
            opacityView.alLeading == view.alLeading,
            opacityView.alTrailing == view.alTrailing,
            opacityView.alTop == view.alTop,
            opacityView.alBottom == view.alBottom
        ])

    }
}
