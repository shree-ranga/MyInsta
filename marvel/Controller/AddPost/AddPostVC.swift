//
//  AddPostVC.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-16.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit

class AddPostVC: UIViewController {
    
    var addPostView: AddPostView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        addPostView = AddPostView(frame: UIScreen.main.bounds)
        view.addSubview(addPostView)
    }
    
}
