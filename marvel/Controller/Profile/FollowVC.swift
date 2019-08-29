//
//  FollowVC.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-22.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit

class FollowVC: UIViewController {
    
    var followView: FollowView!
    
    var isFollowers = false
    var isFollowing = false
    
    var user: User?
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureCollectionView()
        configureNavbar()
        fetchUsers()
    }
    
    func setupViews() {
        followView = FollowView(frame: UIScreen.main.bounds)
        view.addSubview(followView)
    }
    
    func configureCollectionView() {
        followView.collectionView.delegate = self
        followView.collectionView.dataSource = self
        followView.collectionView.register(FollowCell.self, forCellWithReuseIdentifier: FollowCell.cellId)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        followView.collectionView.refreshControl = refreshControl
    }
    
    // MARK: - Refresh
    @objc func handleRefresh() {
        users.removeAll(keepingCapacity: false)
        fetchUsers()
        followView.collectionView.reloadData()
    }
    
    func configureNavbar() {
        if isFollowers {
            navigationItem.title = "Followers"
        } else {
            navigationItem.title = "Following"
        }
    }
    
    func fetchUsers() {
        if isFollowers {
            fetchAllFollowers()
        } else {
            fetchAllFollowing()
        }
    }
    
    func fetchAllFollowers() {
        print("Fetching followers")
        guard let currentUser = user else { return }
        let uid = currentUser.id
        guard let url = URL(string: USERS_URL + "\(uid)/followers/") else { return }
        API.makeRequest(toURL: url, withHttpMethod: .get) { (res) in
            if let error = res.error {
                print(error.localizedDescription)
                return
            }
            
            if let response = res.response {
                print(response.httpStatusCode)
            }
            
            if let data = res.data{
                let decoder = JSONDecoder()
                let userList = try? decoder.decode([User].self, from: data)
                guard let users = userList else { return }
                self.users = users
            }
            
            DispatchQueue.main.async {
                self.followView.collectionView.refreshControl?.endRefreshing()
                self.followView.collectionView.reloadData()
            }
        }
    }
    
    func fetchAllFollowing() {
        print("Fetching following")
        guard let currentUser = user else { return }
        let uid = currentUser.id
        guard let url = URL(string: ACCOUNTS_URL + "users/\(uid)/following/") else { return }
        API.makeRequest(toURL: url, withHttpMethod: .get) { (res) in
            if let error = res.error {
                print(error.localizedDescription)
                return
            }
            
            if let response = res.response {
                print(response.httpStatusCode)
            }
            
            if let data = res.data{
                let decoder = JSONDecoder()
                let userList = try? decoder.decode([User].self, from: data)
                guard let users = userList else { return }
                self.users = users
            }
            
            DispatchQueue.main.async {
                self.followView.collectionView.refreshControl?.endRefreshing()
                self.followView.collectionView.reloadData()
            }
        }
    }
}

extension FollowVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowCell.cellId, for: indexPath) as! FollowCell
        cell.user = users[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.item]
        
        // profile instance
        let profileVC = ProfileVC()
        profileVC.currentUser = user
        
        // push profile vc
        navigationController?.pushViewController(profileVC, animated: true)
    }
}
