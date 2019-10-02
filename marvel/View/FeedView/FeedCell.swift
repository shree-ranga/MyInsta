//
//  FeedCell.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-09-20.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit
import KeychainAccess

class FeedCell: UICollectionViewCell {
    
    static let cellId = "feedCellId"
    
    var delegate: FeedCellDelegate?
    
    let keyChain = Keychain(server: BASE_URL, protocolType: .http)
    
    var posts: Post? {
        didSet {
            guard let imageUrl = posts?.imageUrl else { return }
            guard let caption = posts?.caption else { return }
            guard let owner = posts?.owner else { return }
            guard let likesCount = posts?.likesCount else { return }
            
            guard let username = owner.userName else { return }
            
            postImageView.loadImage(with: imageUrl)
            
            if caption.isEmpty {
                commentsLabel.isHidden = true
            } else {
                let attributedText = NSMutableAttributedString(string: "\(username)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
                attributedText.append(NSAttributedString(string: " \(caption)", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
                commentsLabel.isHidden = false
                commentsLabel.attributedText = attributedText
            }
            
            usernameLabel.text = username
            
            if let imageUrl = owner.profileImageUrl {
                profileImageView.loadImage(with: imageUrl)
            } else {
                profileImageView.image = UIImage(named: "default")
            }
            
            likesLabel.text = "\(likesCount) likes"
            
            configureLikeButton()
        }
    }
    
    lazy var profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.lightGray
        iv.layer.cornerRadius = 40 / 2
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(handleImageOrUsernameTapped))
        imageTap.numberOfTapsRequired = 1
        iv.addGestureRecognizer(imageTap)
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: Username Label
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(handleImageOrUsernameTapped))
        labelTap.numberOfTapsRequired = 1
        label.addGestureRecognizer(labelTap)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.addTarget(self, action: #selector(handleOptionsTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var postImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleCommentsTapped), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    func configureActionButtons() {
        let sv = UIStackView(arrangedSubviews: [likeButton, commentButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sv)
        sv.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sv.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 0).isActive = true
    }
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        //        label.text = "0 likes"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var commentsLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "username", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " caption text or comments", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "10 HOURS REMAINING"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        //        backgroundColor = .white
        
        addSubview(profileImageView)
        
        profileImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 0).isActive = true
        
        addSubview(optionsButton)
        optionsButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        optionsButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 0).isActive = true
        
        addSubview(postImageView)
        postImageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        postImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        postImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        postImageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
        
        configureActionButtons()
        
        addSubview(likesLabel)
        likesLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 8).isActive = true
        likesLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 0).isActive = true
        
        addSubview(commentsLabel)
        commentsLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor, constant: 8).isActive = true
        commentsLabel.leadingAnchor.constraint(equalTo: likesLabel.leadingAnchor, constant: 0).isActive = true
        commentsLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor, constant: 8).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: commentsLabel.leadingAnchor, constant: 0).isActive = true
    }
    
    func configureLikeButton() {
        guard let post = posts else { return }
        let postId = post.id
        checkIfPostLiked(id: postId) { (liked) in
            if liked {
                DispatchQueue.main.async {
                    self.likeButton.setImage(UIImage(named: "like_selected"), for: .normal)
                }
            } else {
                DispatchQueue.main.async {
                    self.likeButton.setImage(UIImage(named: "like_unselected"), for: .normal)
                }
            }
        }
    }
    
    // MARK: - API
    func checkIfPostLiked(id: Int, completion: @escaping (Bool) -> Void) {
        let token = try? keyChain.get("auth_token")
        
        let url = URL(string: CHECK_POST_LIKE_URL)!
        
        API.requestHttpHeaders.setValue(value: "Token \(token!)", forKey: "Authorization")
        API.requestHttpHeaders.setValue(value: "application/json", forKey: "Content-Type")
        
        API.httpBodyParameters.setValue(value: id, forKey: "post_id")
        
        API.makeRequest(toURL: url, withHttpMethod: .post) { (res) in
            if let error = res.error {
                print(error.localizedDescription)
                return
            }
            
            if let resp = res.response {
                print(resp.httpStatusCode)
            }
            
            if let data = res.data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                guard let dict = json as? [String: Bool] else { return }
                if dict["liked"]! == true {
                    completion(true)
                } else if dict["liked"] == false {
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Handlers
    @objc func handleImageOrUsernameTapped() {
        delegate?.handleImageOrUsernameTapped(for: self)
    }
    
    @objc func handleOptionsTapped() {
        delegate?.handleOptionsTapped(for: self)
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(for: self)
    }
    
    @objc func handleCommentsTapped() {
        delegate?.handleCommentsTapped(for: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
