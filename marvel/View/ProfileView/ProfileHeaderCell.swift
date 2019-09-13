//
//  ProfileHeaderCell.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-16.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit
import KeychainAccess

class ProfileHeaderCell: UICollectionViewCell {
    
    static let cellId = "profileHeaderCellId"
    
    private let keyChain = Keychain(server: BASE_URL, protocolType: .http)
    
    var delegate: ProfileCellDelegate?
    
    var user: User? {
        didSet {
            //            guard let userName = user?.userName else { return }
            guard let fullName = user?.fullName else { return }
            if let imageUrl = user?.profileImageUrl {
                profileImageView.loadImage(with: imageUrl)
            } else {
                profileImageView.image = UIImage(named: "default")
            }
            guard let bio = user?.bio else { return }
            guard let numberOfFollowers = user?.numberOfFollowers else { return }
            guard let numberOfFollowing = user?.numberOfFollowing else { return }
            
            fullNameLabel.text = fullName
            bioTextView.text = bio
            
            let followersAttributedText = NSMutableAttributedString(string: "\(numberOfFollowers)", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
            followersAttributedText.append(NSAttributedString(string: " Followers", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.black]))
            followersLabel.attributedText = followersAttributedText
            
            let followingAttributedText = NSMutableAttributedString(string: "\(numberOfFollowing)", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
            followingAttributedText.append(NSAttributedString(string: " Following", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.black]))
            followingLabel.attributedText = followingAttributedText
            
            configureFollowButton()
        }
    }
    
    // MARK: - profile image view
    let profileImageViewWidthHeight: CGFloat = 80
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
//        iv.image = UIImage(named: "srr")
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
        button.setTitle("Loading...", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        //        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - full name label
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
//        label.text = "Shree Ranga Raju"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - bio text view
    // TODO: - enable links and hashtags
    lazy var bioTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis disap"
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textAlignment = .justified
        //        tv.backgroundColor = .clear
        tv.backgroundColor = .yellow
        tv.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //        tv.textContainer.lineFragmentPadding = 0
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
        
        let attributedText = NSMutableAttributedString(string: "", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: " Followers", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.black]))
        label.attributedText = attributedText
        
        let followersTap = UITapGestureRecognizer()
        followersTap.numberOfTapsRequired = 1
        followersTap.addTarget(self, action: #selector(handleFollowersTapped))
        label.addGestureRecognizer(followersTap)
        label.isUserInteractionEnabled = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - following label
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: " Following", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.black]))
        label.attributedText = attributedText
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        gesture.numberOfTapsRequired = 1
        label.addGestureRecognizer(gesture)
        label.isUserInteractionEnabled = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        
        // MARK: - profile Image anchors
        addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageViewWidthHeight).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageViewWidthHeight).isActive = true
        
        // MARK: - full name label anchors
        addSubview(fullNameLabel)
        fullNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 12).isActive = true
        //        fullNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -8).isActive = true
        //        fullNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 0).isActive = true
        fullNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20).isActive = true
        fullNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        
        // MARK: - follow button anchors
        addSubview(followButton)
        //        followButton.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 16).isActive = true
        followButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -4).isActive = true
        followButton.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        followButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        //        followButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 0).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        // MARK: - bio text view anchors
        addSubview(bioTextView)
        bioTextView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12).isActive = true
        bioTextView.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: -4).isActive = true
        bioTextView.trailingAnchor.constraint(equalTo: followButton.trailingAnchor, constant: 0).isActive = true
        
        // MARK: - followers label anchors
        addSubview(followersLabel)
        followersLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 0).isActive = true
        followersLabel.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 12).isActive = true
        
        // MARK: - following label anchors
        addSubview(followingLabel)
        followingLabel.topAnchor.constraint(equalTo: followersLabel.topAnchor, constant: 0).isActive = true
        followingLabel.leadingAnchor.constraint(equalTo: followersLabel.trailingAnchor, constant: 16).isActive = true
    }
    
    // MARK: - Handlers
    @objc func handleFollowTapped() {
        delegate?.handleFollowTapped(for: self)
    }
    
    @objc func handleFollowersTapped() {
        delegate?.handleFollowersTapped(for: self)
    }
    
    @objc func handleFollowingTapped() {
        delegate?.handleFollowingTapped(for: self)
    }
    
    func configureFollowButton() {
        guard let user = user else { return }
        // TODO: - Move this to login page
        guard let loggedInUserId = Int(keyChain["id"]!) else { return }
        let userId = user.id
        
        if loggedInUserId == userId {
            followButton.setTitle("Edit Profile", for: .normal)
        } else {
            checkIfUserIsFollowed(id: userId) { (followed) in
                if followed {
                    DispatchQueue.main.async {
                        self.followButton.setTitle("Following", for: .normal)
                        self.followButton.setTitleColor(UIColor.white, for: .normal)
                        self.followButton.backgroundColor = UIColor.darkGray
                        self.followButton.layer.borderColor = UIColor.darkGray.cgColor
                    }
                } else {
                    DispatchQueue.main.async {
                        self.followButton.setTitle("Follow", for: .normal)
                        self.followButton.setTitleColor(UIColor.white, for: .normal)
                        self.followButton.backgroundColor = UIColor.blue
                        self.followButton.layer.borderColor = UIColor.blue.cgColor
                    }
                }
            }
        }
    }
    
    func checkIfUserIsFollowed(id: Int, completion: @escaping (Bool) -> Void) {
        let token = keyChain["auth_token"]
        API.requestHttpHeaders.setValue(value: "Token \(token!)", forKey: "Authorization")
        API.requestHttpHeaders.setValue(value: "application/json", forKey: "Content-Type")
        API.httpBodyParameters.setValue(value: id, forKey: "following_user_id")
        let url = URL(string: CHECK_FOLLOW_URL)!
        API.makeRequest(toURL: url, withHttpMethod: .post) { (res) in
            if let error = res.error {
                print(error.localizedDescription)
            }
            
            if let response = res.response {
                print(response.httpStatusCode)
            }
            
            if let data = res.data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                guard let dict = json as? [String: Bool] else { return }
                if dict["following"]! == true {
                    completion(true)
                } else if dict["following"]! == false{
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

