//
//  WebViewController.swift
//  GitHubSearch
//
//  Created by Maxim Kovalko on 6/21/18.
//  Copyright © 2018 Maxim Kovalko. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    lazy var webView = createWebView()
    lazy var closeButton = createButton(title: "Close")
    
    let url: String
    var closeAction: (() -> ())?
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        initViews()
        
        URL(string: url).do { webView.loadRequest(.init(url: $0)) }
    }
    
    @objc private func close(_ sender: UIButton) {
        closeAction?()
    }
    
}

//MARK: - Create Views

extension WebViewController {
    func createWebView() -> UIWebView {
        let webView = UIWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .white
        return webView
    }
    
    func createButton(title: String) -> UIButton {
        let configure = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setTitleColor(.lightGray, for: .highlighted)
            $0.backgroundColor = .darkGray
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5
            $0.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        } as (UIButton) -> Void
        
        let button = UIButton()
        configure(button)
        return button
    }
}

//MARK: - Init Views

private let padding: CGFloat = 20
private let height: CGFloat = 44
private let closeButtonBottomPadding: CGFloat = 8
private let webViewBottomPadding: CGFloat = 54

extension WebViewController {
    func initViews() {
        initWebView()
        initCloseButton()
        view.backgroundColor = .white
    }
    
    private func initWebView() {
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.alLeading == view.alLeading,
            webView.alTrailing == view.alTrailing,
            webView.alTop == view.alTop,
            webView.alBottom == view.alBottom - webViewBottomPadding
        ])
    }
    
    private func initCloseButton() {
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.alLeading == view.alLeading + padding,
            closeButton.alTrailing == view.alTrailing - padding,
            closeButton.alHeight == height,
            closeButton.alBottom == view.alBottom - closeButtonBottomPadding
        ])
    }
}
