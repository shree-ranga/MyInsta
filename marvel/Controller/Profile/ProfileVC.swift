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
    
    var uid: String!
    
    var isLoggedInUser: Bool = false
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        configureCollectionView()
        
        if currentUser == nil {
            let currentUid = try? keyChain.get("id")
            uid = currentUid
            isLoggedInUser = true
        }
        
        if let currentUser = currentUser {
            uid = "\(currentUser.id)"
            isLoggedInUser = false
        }
        
        fetchCurrentUserData(uid: uid!)
        fetchPostsData(uid: uid)
    }
    
    func setupViews() {
        profileView = ProfileView(frame: UIScreen.main.bounds)
        view.addSubview(profileView)
    }
    
    func configureCollectionView() {
        profileView.collectionView.delegate = self
        profileView.collectionView.dataSource = self
        
        // cell registration
        profileView.collectionView.register(ProfileHeaderCell.self, forCellWithReuseIdentifier: ProfileHeaderCell.cellId)
        profileView.collectionView.register(GridCell.self, forCellWithReuseIdentifier: GridCell.cellId)
        
        // refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        profileView.collectionView.refreshControl = refreshControl
    }
    
    // MARK: - Refresh
    @objc func handleRefresh() {
        fetchCurrentUserData(uid: uid!)
        posts.removeAll(keepingCapacity: false)
        fetchPostsData(uid: uid!)
        profileView.collectionView.reloadData()
    }
    
    // MARK: - API Calls
    
    func fetchCurrentUserData(uid: String) {
        print("Fetching current user data")
        let token = try? keyChain.get("auth_token")
        let url = URL(string: USERS_URL + uid)!
        
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
                let decoder = JSONDecoder()
                let user = try? decoder.decode(User.self, from: data)
                self.currentUser = user
            }
            
            DispatchQueue.main.async {
                self.navigationItem.title = self.currentUser?.userName
                self.profileView.collectionView.reloadData()
                self.profileView.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
    // follow
    func follow(id: Int, token: String, cell: ProfileHeaderCell) {
        let url = URL(string: FOLLOW_UNFOLLOW_URL)!
        API.requestHttpHeaders.setValue(value: "application/json", forKey: "Content-Type")
        API.requestHttpHeaders.setValue(value: "Token \(token)", forKey: "Authorization")
        API.httpBodyParameters.setValue(value: id, forKey: "following_user_id")
        API.makeRequest(toURL: url, withHttpMethod: .post) { (res) in
            if let error = res.error {
                print(error.localizedDescription)
                return
            }
            
            if let response = res.response {
                print(response.httpStatusCode)
            }
            
            DispatchQueue.main.async {
                cell.followButton.setTitle("Following", for: .normal)
                cell.followButton.setTitleColor(.white, for: .normal)
                cell.followButton.backgroundColor = UIColor.darkGray
                cell.followButton.layer.borderColor = UIColor.darkGray.cgColor
            }
        }
    }
    
    // unfollow
    func unfollow(id: Int, token: String, cell: ProfileHeaderCell) {
        let url = URL(string: FOLLOW_UNFOLLOW_URL)!
        API.requestHttpHeaders.setValue(value: "application/json", forKey: "Content-Type")
        API.requestHttpHeaders.setValue(value: "Token \(token)", forKey: "Authorization")
        API.httpBodyParameters.setValue(value: id, forKey: "following_user_id")
        API.makeRequest(toURL: url, withHttpMethod: .delete) { (res) in
            if let error = res.error {
                print(error.localizedDescription)
                return
            }
            
            if let response = res.response {
                print(response.httpStatusCode)
            }
            
            DispatchQueue.main.async {
                cell.followButton.setTitle("Follow", for: .normal)
                cell.followButton.setTitleColor(.white, for: .normal)
                cell.followButton.backgroundColor = UIColor.blue
                cell.followButton.layer.borderColor = UIColor.blue.cgColor
            }
        }
    }
    
    // user posts
    func fetchPostsData(uid: String) {
        print("Fetching User Posts....")
        let token = try? keyChain.get("auth_token")
        
        let url = URL(string: USER_POSTS_URL)!
        
        API.httpBodyParameters.setValue(value: uid, forKey: "user_id")
        
        API.requestHttpHeaders.setValue(value: "Token \(token!)", forKey: "Authorization")
        API.requestHttpHeaders.setValue(value: "application/json", forKey: "Content-Type")
        
        API.makeRequest(toURL: url, withHttpMethod: .post) { (res) in
            if let error = res.error {
                print(error.localizedDescription)
                return
            }
            
            if let response = res.response {
                print(response.httpStatusCode)
            }
            
            if let data = res.data {
                let decoder = JSONDecoder()
                let postList = try? decoder.decode([Post].self, from: data)
                guard let posts = postList else { return }
                self.posts = posts
            }
            
            DispatchQueue.main.async {
                self.profileView.collectionView.reloadData()
                self.profileView.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension ProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileHeaderCell.cellId, for: indexPath) as! ProfileHeaderCell
            cell.delegate = self
            cell.user = currentUser
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCell.cellId, for: indexPath) as! GridCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 208)
        }
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension ProfileVC: ProfileCellDelegate {
    func handleFollowTapped(for cell: ProfileHeaderCell) {
        guard let user = cell.user else { return }
        let token = try? keyChain.get("auth_token")
        
        if cell.followButton.titleLabel?.text == "Edit Profile" {
            print("Edit Profile")
        } else if cell.followButton.titleLabel?.text == "Follow" {
            follow(id: user.id, token: token!, cell: cell)
        } else {
            unfollow(id: user.id, token: token!, cell: cell)
        }
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
