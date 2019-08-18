//
//  SearchVC.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-16.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    var searchView: SearchView!
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        configureCollectionView()
        
        fetchAllUsers()
        
    }
    
    func setupViews() {
        searchView = SearchView(frame: UIScreen.main.bounds)
        view.addSubview(searchView)
    }
    
    func configureCollectionView() {
        searchView.collectionView.delegate = self
        searchView.collectionView.dataSource = self
        searchView.collectionView.register(SearchViewCell.self, forCellWithReuseIdentifier: SearchViewCell.cellId)
    }
    
    // MARK: - API calls
    func fetchAllUsers() {
        guard let url = URL(string: ACCOUNTS_URL + "users/") else { return }
        API.makeRequest(toURL: url, withHttpMethod: .get) { (res) in
            if let error = res.error {
                print(error.localizedDescription)
            }
            
            if let response = res.response {
                print(response.httpStatusCode)
            }
            
            if let data = res.data {
                // before swift 4
//                let json = try? JSONSerialization.jsonObject(with: data, options: [])
//                let jsonArray = json as! [[String: Any]]
//                print(jsonArray)
                let decoder = JSONDecoder()
                let userList = try! decoder.decode([User].self, from: data)
                self.users = userList
            }
            
            // reload collection view
            DispatchQueue.main.async {
                self.searchView.collectionView.reloadData()
            }
        }
    }
}

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewCell.cellId, for: indexPath) as! SearchViewCell
        cell.user = users[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
}
