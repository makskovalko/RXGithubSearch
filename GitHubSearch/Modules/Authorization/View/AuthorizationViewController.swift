//
//  AuthorizationAuthorizationViewController.swift
//  GitHubSearch
//
//  Created by Maksim Kovalko (Kharkiv) on 18/06/2018.
//  Copyright © 2018 Maksym Kovalko. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController, AuthorizationViewInput {

    var output: AuthorizationViewOutput!
    
    lazy var loginTextField = createTextField(placeholder: "Enter Login")
    lazy var passwordTextField = createTextField(placeholder: "Enter Password", isSecureText: true)
    lazy var loginButton = createButton(withTitle: "Login")
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        output.viewIsReady()
        
        view.backgroundColor = .white
    }

    // MARK: AuthorizationViewInput
    
    func setupInitialState() {}
    
    @objc private func loginTapped(_ sender: UIButton) {
        guard let login = loginTextField.text,
            let password = passwordTextField.text else { return }
        output.logIn(userName: login, password: password)
    }
    
    func showError(_ error: Error) {
        showAlert(title: "Error", message: .init(describing: error))
    }
}

//MARK: - Create Views

extension AuthorizationViewController {
    func createTextField(placeholder: String,
                         text: String = "",
                         isSecureText: Bool = false) -> UITextField {
        let configure = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.placeholder = placeholder
            $0.borderStyle = .roundedRect
            $0.text = text
            $0.isSecureTextEntry = isSecureText
        } as (UITextField) -> Void
        
        let textField = UITextField()
        configure(textField)
        return textField
    }
    
    func createButton(withTitle title: String) -> UIButton {
        let configure = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setTitleColor(.darkGray, for: .highlighted)
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(self.loginTapped), for: .touchUpInside)
        } as (UIButton) -> Void
        
        let button = UIButton()
        configure(button)
        return button
    }
}

//MARK: - Init Views

extension AuthorizationViewController {
    func initViews() {
        navigationItem.title = "Login"
        
        initTextFields()
        initButton()
    }
    
    func initTextFields() {
        [loginTextField, passwordTextField].forEach {
            let textField = $0
            view.addSubview(textField)
            
            NSLayoutConstraint.activate([
                textField.alHeight == 30,
                textField.alLeading == view.alLeading + 20,
                textField.alTrailing == view.alTrailing - 20,
            ])
        }
        
        NSLayoutConstraint.activate([
            loginTextField.alCenterY == view.alCenterY - 40,
            passwordTextField.alCenterY == loginTextField.alBottom + 20
        ])
    }
    
    func initButton() {
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.alWidth == 150,
            loginButton.alHeight == 44,
            loginButton.alCenterX == view.alCenterX,
            loginButton.alTop == passwordTextField.alBottom + 20
        ])
    }
}
