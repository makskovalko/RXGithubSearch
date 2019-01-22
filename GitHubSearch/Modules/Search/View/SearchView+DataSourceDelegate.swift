//
//  SearchView+DataSourceDelegate.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/21/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import UIKit

//MARK: - TableView DataSource

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle,
                                   reuseIdentifier: NSStringFromClass(UITableViewCell.self))
        let viewModel = output.viewModels[indexPath.row]
        let bind = {
            $0.textLabel?.text = viewModel.title
            $0.detailTextLabel?.text = viewModel.description
        } as (UITableViewCell) -> Void
        bind(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return output.viewModels.count == 0 ? "No repositories" : nil
    }
}

//MARK: - TableView Delegate

extension SearchViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webViewController = WebViewController(url: output.viewModels[indexPath.row].url)
        
        webViewController.closeAction = {
            self.overlayView.isHidden = true
            self.opacityView.isHidden = true
            webViewController.removeAsChild()
        }
        
        UIView.transition(
            with: view,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: { [unowned self] in
                self.overlayView.isHidden = false
                self.opacityView.isHidden = false
                self.addChild(
                    viewController: webViewController,
                    in: self.overlayView
                )
        }, completion: nil)
    }
}
