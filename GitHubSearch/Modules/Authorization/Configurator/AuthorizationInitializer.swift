//
//  AuthorizationAuthorizationInitializer.swift
//  GitHubSearch
//
//  Created by Maksim Kovalko (Kharkiv) on 18/06/2018.
//  Copyright © 2018 Maksym Kovalko. All rights reserved.
//

import UIKit

class AuthorizationModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var authorizationViewController: AuthorizationViewController!

    override func awakeFromNib() {

        let configurator = AuthorizationModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: authorizationViewController)
    }

}
