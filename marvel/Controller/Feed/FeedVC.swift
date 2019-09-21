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
    
    var feedView: FeedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureNavBar()
        configureCV()
    }
    
    func setupViews() {
        feedView = FeedView(frame: UIScreen.main.bounds)
        view.addSubview(feedView)
    }
    
    func configureNavBar() {
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    func configureCV() {
        feedView.collectionView.delegate = self
        feedView.collectionView.dataSource = self
        feedView.collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.cellId)
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
                self.keyChain["id"] = nil
                let loginVC = LoginVC()
                self.present(loginVC, animated: true, completion: nil)
            }
            print("Logout Successful...")
        }
    }
}

extension FeedVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.cellId, for: indexPath) as! FeedCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width + 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
