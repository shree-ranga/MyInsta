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
                guard let dict = jsonResponse as? Dictionary<String, AnyObject> else { return }
                //TODO: - Handle incorrect password
                let token = dict["token"] as! String
                let id = dict["id"] as! Int
                self.keyChain["auth_token"] = token
                self.keyChain["id"] = "\(id)"
                print("Login Successful....")
                DispatchQueue.main.async {
                    let mainVC = MainTabBarVC()
                    mainVC.modalPresentationStyle = .fullScreen
                    self.present(mainVC, animated: true, completion: nil)
                }
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func handleSignup(for view: LoginView) {
        let signupVC = SignupVC()
        present(signupVC, animated: true, completion: nil)
    }
}
