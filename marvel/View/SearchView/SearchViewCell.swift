//
//  SearchViewCell.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-17.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit

class SearchViewCell: UICollectionViewCell {
    
    static let cellId = "searchViewCellId"
    
    var user: User? {
        didSet {
            configureCell()
        }
    }
    
    let profileImageViewHeight: CGFloat = 48
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.layer.cornerRadius = profileImageViewHeight / 2
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "shreerangaraju"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Shree Ranga Raju"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        // MARK: - profile image view anchors
        addSubview(profileImageView)
        profileImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageViewHeight).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageViewHeight).isActive = true
        
        // MARK: - user name label anchors
        addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12).isActive = true
        
        // MARK: - full name label anchors
        addSubview(fullNameLabel)
        fullNameLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4).isActive = true
        fullNameLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor, constant: 0).isActive = true
    }
    
    func configureCell() {
        //            guard let userName = user?.userName else { return }
        //            guard let fullName = user?.fullName else { return }
        //            guard let profileImageUrl = user?.profileImageUrl else { return }
        
        userNameLabel.text = user?.userName
        fullNameLabel.text = user?.fullName
        
        if let profileImageUrl = user?.profileImageUrl {
            profileImageView.loadImage(with: profileImageUrl)
        } else {
            profileImageView.image = UIImage(named: "default")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
