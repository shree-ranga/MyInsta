//
//  SignupView.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-06.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit

class SignupView: UIView {
    
    lazy var profileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "default")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    lazy var fullNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocorrectionType = .no
        return tf
    }()
    
    lazy var userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        return tf
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        return tf
    }()
    
    lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.blue
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    lazy var signinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(UIColor(red: 0/255, green: 145/255, blue: 235/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignin), for: .touchUpInside)
        return button
    }()
    
    var delegate: SignupViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .white
        addSubview(profileImageButton)
        addSubview(signinButton)
        
        configureViewComponents()
        
        profileImageButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        profileImageButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        profileImageButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        profileImageButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        signinButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        signinButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
    }
    
    func configureViewComponents() {
        let loginStackView = UIStackView(arrangedSubviews: [ fullNameTextField, userNameTextField, emailTextField, passwordTextField, signupButton])
        loginStackView.axis = .vertical
        loginStackView.spacing = 10
        loginStackView.distribution = .fillEqually
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(loginStackView)
        loginStackView.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 40).isActive = true
        loginStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        loginStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
        loginStackView.heightAnchor.constraint(equalToConstant: 260).isActive = true
    }
    
    @objc func handleSignin() {
        delegate?.handleSignin(for: self)
    }
    
    @objc func handleSignup() {
        delegate?.handleSignup(for: self)
    }
    
    @objc func handleSelectPhoto() {
        delegate?.handleSelectPhoto(for: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
