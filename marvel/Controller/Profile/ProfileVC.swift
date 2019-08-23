//
//  ProfileVC.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-16.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit
import KeychainAccess

class ProfileVC: UIViewController {
    private let keyChain = Keychain(server: BASE_URL, protocolType: .http)
    
    var profileView: ProfileView!
    
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        configureCollectionView()
        
        if currentUser == nil {
            fetchCurrentUserData()
        }
        
        if let currentUser = currentUser {
            navigationItem.title = currentUser.userName
        }
    }
    
    func setupViews() {
        profileView = ProfileView(frame: UIScreen.main.bounds)
        view.addSubview(profileView)
    }
    
    func configureCollectionView() {
        profileView.collectionView.delegate = self
        profileView.collectionView.dataSource = self
        profileView.collectionView.register(ProfileHeaderCell.self, forCellWithReuseIdentifier: ProfileHeaderCell.cellId)
    }
    
    // MARK: - API Calls
    
    func fetchCurrentUserData() {
        let token = try? keyChain.get("auth_token")

        guard let url = URL(string: ACCOUNTS_URL + "users/me/") else { return }
        
        API.requestHttpHeaders.setValue(value: "Token \(token!)", forKey: "Authorization")
        API.makeRequest(toURL: url, withHttpMethod: .get) { (res) in
            if let error = res.error {
                print(error.localizedDescription)
                return
            }
            
            if let response = res.response {
                print(response.httpStatusCode)
            }
            
            if let data = res.data {
//                let json = try? JSONSerialization.jsonObject(with: data, options: [])
//                print(json!)
                let decoder = JSONDecoder()
                let user = try? decoder.decode(User.self, from: data)
                self.currentUser = user
            }
            
            DispatchQueue.main.async {
                self.navigationItem.title = self.currentUser?.userName
                self.profileView.collectionView.reloadData()
            }
        }
    }
    
}

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileHeaderCell.cellId, for: indexPath) as! ProfileHeaderCell
        cell.delegate = self
        cell.user = currentUser
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 250)
    }
    
}

extension ProfileVC: ProfileCellDelegate {
    func handleFollowTapped(for cell: ProfileHeaderCell) {
        print("Follow button tapped")
    }
    
    func handleFollowersTapped(for cell: ProfileHeaderCell) {
        let followVC = FollowVC()
        followVC.isFollowers = true
        followVC.user = currentUser
        navigationController?.pushViewController(followVC, animated: true)
    }
    
    func handleFollowingTapped(for cell: ProfileHeaderCell) {
        let followVC = FollowVC()
        followVC.isFollowing = true
        followVC.user = currentUser
        navigationController?.pushViewController(followVC, animated: true)
    }
}
