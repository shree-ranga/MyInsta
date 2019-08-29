//
//  FeedVC.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-16.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit
import KeychainAccess

class FeedVC: UIViewController {
    
    let keyChain = Keychain(server: BASE_URL, protocolType: .http)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
    }
    
    func configureNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    // MARK: - Handlers
    @objc func handleLogout() {
        let token = try? keyChain.get("auth_token")
        
        guard let logoutUrl = URL(string: LOGOUT_URL) else { return }
        
        API.requestHttpHeaders.setValue(value: "Token \(token!)", forKey: "Authorization")
        
        // first delete the token from the server
        API.makeRequest(toURL: logoutUrl, withHttpMethod: .delete) { (res) in
            if let error = res.error {
                print("Unable to logout -", error.localizedDescription)
                return
            }
            
            if let response = res.response {
                print(response.httpStatusCode)
            }
            
            DispatchQueue.main.async {
                // delete the token from the keychain
                self.keyChain["auth_token"] = nil
                self.keyChain["loggedInUserId"] = nil
                let loginVC = LoginVC()
                self.present(loginVC, animated: true, completion: nil)
            }
            print("Logout Successful...")
        }
    }
}
