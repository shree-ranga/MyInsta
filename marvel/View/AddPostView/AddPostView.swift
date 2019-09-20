//
//  AddPostView.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-09-13.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit

class AddPostView: UIView {
    
    lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var captionTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .yellow
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .white
        
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(captionTextView)
        captionTextView.topAnchor.constraint(equalTo: photoImageView.topAnchor, constant: 0).isActive = true
        captionTextView.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 12).isActive = true
        captionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        captionTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
