//
//  ProfileHeaderCell.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-16.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UICollectionViewCell {
    
    static let cellId = "profileHeaderCellId"
    
    var user: User? {
        didSet {
//            guard let userName = user?.userName else { return }
            guard let fullName = user?.fullName else { return }
            guard let imageUrl = user?.profileImageUrl else { return }
            
            fullNameLabel.text = fullName
            profileImageView.loadImage(with: imageUrl)
        }
    }
    
    // MARK: - profile image view
    let profileImageViewWidthHeight: CGFloat = 80
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.image = UIImage(named: "srr")
        iv.layer.cornerRadius = profileImageViewWidthHeight / 2
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor.lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: - follow button
    lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - full name label
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Shree Ranga Raju"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - bio text view
    // TODO: - enable links and hashtags
    lazy var bioTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis disap"
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.backgroundColor = .clear
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.isSelectable = false
        tv.isUserInteractionEnabled = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - followers label
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: " Followers", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]))
        label.attributedText = attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - following label
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: " Following", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]))
        label.attributedText = attributedText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        // cell background color
//        backgroundColor = .yellow
        
        // MARK: - profile Image anchors
        addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageViewWidthHeight).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageViewWidthHeight).isActive = true
        
        // MARK: - follow button anchors
        addSubview(followButton)
        followButton.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        followButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        followButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 0).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        // MARK: - full name label anchors
        addSubview(fullNameLabel)
        fullNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16).isActive = true
        fullNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 0).isActive = true
        
        // MARK: - bio text view anchors
        addSubview(bioTextView)
        bioTextView.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 0).isActive = true
        bioTextView.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: -4).isActive = true
        bioTextView.trailingAnchor.constraint(equalTo: followButton.trailingAnchor, constant: 0).isActive = true
        
        // MARK: - followers label anchors
        addSubview(followersLabel)
        followersLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 0).isActive = true
        followersLabel.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 4).isActive = true
        
        // MARK: - following label anchors
        addSubview(followingLabel)
        followingLabel.topAnchor.constraint(equalTo: followersLabel.topAnchor, constant: 0).isActive = true
        followingLabel.leadingAnchor.constraint(equalTo: followersLabel.trailingAnchor, constant: 16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
