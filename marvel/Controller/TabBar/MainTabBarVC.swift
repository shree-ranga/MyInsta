//
//  TabBar.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-16.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        tabBar.tintColor = .black
        
        let feedVC = configureNavBar(selectedImage: UIImage(named: "home_selected"), unselectedImage: UIImage(named: "home_unselected"), rootVC: FeedVC())
        
        let searchVC = configureNavBar(selectedImage: UIImage(named: "search_selected"), unselectedImage: UIImage(named: "search_unselected"), rootVC: SearchVC())
        
        let addPostVC = configureNavBar(selectedImage: UIImage(named: "plus_unselected"), unselectedImage: UIImage(named: "plus_unselected"), rootVC: AddPostVC())
        
        let notificationsVC = configureNavBar(selectedImage: UIImage(named: "like_selected"), unselectedImage: UIImage(named: "like_unselected"), rootVC: NotificationsVC())
        
        let profileVC = configureNavBar(selectedImage: UIImage(named: "profile_selected"), unselectedImage: UIImage(named: "profile_unselected"), rootVC: ProfileVC())
        
        viewControllers = [feedVC, searchVC, addPostVC, notificationsVC, profileVC]
        
    }
    
    func configureNavBar(selectedImage: UIImage?, unselectedImage: UIImage?, rootVC: UIViewController = UIViewController()) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        navVC.tabBarItem.image = unselectedImage?.withRenderingMode(.alwaysOriginal)
        navVC.navigationBar.tintColor = .black
        return navVC
    }
}
