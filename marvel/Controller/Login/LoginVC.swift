//
//  LoginVC.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-05.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit
import KeychainAccess

class LoginVC: UIViewController {
    
    var loginView: LoginView!
    private let keyChain = Keychain(server: BASE_URL, protocolType: .http)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loginView.delegate = self
    }
    
    func setupViews() {
        loginView = LoginView(frame: UIScreen.main.bounds)
        view.addSubview(loginView)
    }
    
}

extension LoginVC: LoginViewDelegate {
    
    func handleLogin(for view: LoginView) {
        guard let email = loginView.emailTextField.text else { return }
        guard let password = loginView.passwordTextField.text else { return }
        
        guard let loginUrl = URL(string: LOGIN_URL) else { return }
        
        API.requestHttpHeaders.setValue(value: "application/json", forKey: "Content-Type")
        API.httpBodyParameters.setValue(value: email.lowercased(), forKey: "email")
        API.httpBodyParameters.setValue(value: password.lowercased(), forKey: "password")
        
        API.makeRequest(toURL: loginUrl, withHttpMethod: .post) { (res) in
            if let error = res.error {
                print(error.localizedDescription)
            }

            if let statusCode = res.response {
                print(statusCode.httpStatusCode)
            }

            guard let data = res.data else { return }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                let dict = jsonResponse as! Dictionary<String, AnyObject>

                if let token = dict["token"] {
                    let auth_token = token as! String
                    do {
                        try self.keyChain.set(auth_token, key: "auth_token")
                        print("Login Successful...")
                    } catch let error{
                        print(error.localizedDescription)
                    }
                    DispatchQueue.main.async {
                        let mainVC = MainTabBarVC()
                        self.present(mainVC, animated: true, completion: nil)
                    }
                } else {
                    print(dict.values)
                }
            } catch let error{
                print(error.localizedDescription)
            }
        }
    }
    
    func handleSignup(for view: LoginView) {
        let signupVC = SignupVC()
        present(signupVC, animated: true, completion: nil)
    }
}
