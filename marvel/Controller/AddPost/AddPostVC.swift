//
//  AddPostVC.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-16.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit
import KeychainAccess

class AddPostVC: UIViewController {
    
    var addPostView: AddPostView!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureNavBar()
        loadImage()
    }
    
    func setupViews() {
        addPostView = AddPostView(frame: UIScreen.main.bounds)
        view.addSubview(addPostView)
    }
    
    func configureNavBar() {
        navigationItem.title = "New Post"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    }
    
    func loadImage() {
        if let selectedImage = selectedImage {
            addPostView.photoImageView.image = selectedImage
        }
    }
    
    @objc func handleShare() {
        print("Share button tapped")
    }
    
}
