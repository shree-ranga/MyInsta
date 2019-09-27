//
//  LoginView.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-05.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.textColor = UIColor.black
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.autocorrectionType = .no
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.textColor = UIColor.black
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.blue
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
//        button.isEnabled = false
        return button
    }()
    
    lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor(red: 0/255, green: 145/255, blue: 235/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    var delegate: LoginViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .white
        addSubview(signupButton)
        configureViewComponents()
        
        signupButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        signupButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
    }
    
    func configureViewComponents() {
        let loginStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        loginStackView.axis = .vertical
        loginStackView.spacing = 10
        loginStackView.distribution = .fillEqually
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(loginStackView)

        loginStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        loginStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        loginStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
        loginStackView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    @objc func handleLogin() {
        delegate?.handleLogin(for: self)
    }
    
    @objc func handleSignup() {
        delegate?.handleSignup(for: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
