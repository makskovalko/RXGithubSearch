//
//  UIViewController+Extension.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/21/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChild(viewController: UIViewController, in view: UIView) {
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = viewController.view
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[subView]|",
            options: [],
            metrics: nil,
            views: viewBindingsDict)
        )
        
        view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[subView]|",
            options: [],
            metrics: nil,
            views: viewBindingsDict)
        )
        
        viewController.didMove(toParentViewController: self)
    }
    
    func removeAsChild() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "OK", style: .default, handler: { action in }
        ))
        
        present(alert, animated: true, completion: nil)
    }
}
