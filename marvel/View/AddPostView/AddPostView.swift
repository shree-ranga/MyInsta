//
//  AddPostView.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-09-13.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit

class AddPostView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = UIColor.green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
