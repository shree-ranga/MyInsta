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
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureNavBar()
        configureCV()
        fetchFeed()
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
        
        // cell registration
        feedView.collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.cellId)
        
        // refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        feedView.collectionView.refreshControl = refreshControl
    }
    
    // MARK: - Handlers
    @objc func handleRefresh() {
        posts.removeAll(keepingCapacity: false)
        fetchFeed()
        feedView.collectionView.reloadData()
    }
    
    
    @objc func handleLogout() {
        logout()
    }
    
    // MARK: - API calls
    
    // fetch posts
    func fetchFeed() {
        print("Fetching User Feed....")
        let token = try? keyChain.get("auth_token")
        
        let url = URL(string: FEED_URL)!
        
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
                let postsList = try? decoder.decode([Post].self, from: data)
                guard let posts = postsList else { return }
                self.posts = posts
            }
            
            DispatchQueue.main.async {
                self.feedView.collectionView.reloadData()
                self.feedView.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
    
    // logout
    func logout() {
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
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            }
            print("Logout Successful...")
        }
    }
    
    func like(cell: FeedCell) {
        let token = try? keyChain.get("auth_token")

        guard let post = cell.posts else { return }
        let postId = post.id
        
        let url = URL(string: LIKE_URL)!
        
        API.requestHttpHeaders.setValue(value: "Token \(token!)", forKey: "Authorization")
        API.requestHttpHeaders.setValue(value: "application/json", forKey: "Content-Type")
        
        API.httpBodyParameters.setValue(value: "\(postId)", forKey: "post_id")
        
        API.makeRequest(toURL: url, withHttpMethod: .post) { (res) in
            if let error = res.error {
                print("Unable to like", error.localizedDescription)
                return
            }
            
            if let response = res.response {
                print(response.httpStatusCode)
            }
            
            if let data = res.data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                print(json!)
            }
            DispatchQueue.main.async {
                cell.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
            }
        }
    }
    
    func unlike(cell: FeedCell) {
        let token = try? keyChain.get("auth_token")

        guard let post = cell.posts else { return }
        let postId = post.id
        
        let url = URL(string: UNLIKE_URL)!
        
        API.requestHttpHeaders.setValue(value: "Token \(token!)", forKey: "Authorization")
        API.requestHttpHeaders.setValue(value: "application/json", forKey: "Content-Type")
        
        API.httpBodyParameters.setValue(value: "\(postId)", forKey: "post_id")
        
        API.makeRequest(toURL: url, withHttpMethod: .delete) { (res) in
            if let error = res.error {
                print(error.localizedDescription)
                return
            }
            
            if let response = res.response {
                print(response.httpStatusCode)
            }
            
            DispatchQueue.main.async {
                cell.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
            }
        }
    }
}

// MARK: - CollectionView delegate methods
extension FeedVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.cellId, for: indexPath) as! FeedCell
        cell.delegate = self
        cell.posts = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width + 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Feed cell delegate
extension FeedVC: FeedCellDelegate {
    func handleImageOrUsernameTapped(for cell: FeedCell) {
        print("image or username tappes")
        guard let user = cell.posts?.owner else { return }
        let profileVC = ProfileVC()
        profileVC.currentUser = user
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func handleOptionsTapped(for cell: FeedCell) {
        print("options tapped")
    }
    
    func handleLikeTapped(for cell: FeedCell) {
        if cell.likeButton.image(for: .normal) == UIImage(named: "like_selected") {
            unlike(cell: cell)
            cell.posts?.likesCount! -= 1
        } else {
            like(cell: cell)
            cell.posts?.likesCount! += 1
        }
    }
    
    func handleCommentsTapped(for cell: FeedCell) {
        print("comments tapped")
    }
}
