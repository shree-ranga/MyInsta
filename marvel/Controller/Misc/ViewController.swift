//
//  ViewController.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-07-03.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit
import KeychainAccess

class ViewController: UIViewController {
    
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 150 / 2
        iv.backgroundColor = .lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.blue
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleUpload), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let keyChain = Keychain(server: BASE_URL, protocolType: .http)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        let myUrl = URL(string: BASE_URL + "accounts/dummy/")!
        API.makeRequest(toURL: myUrl, withHttpMethod: .get) { (res) in
            guard let data = res.data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            print(json)
        }
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.groupTableViewBackground
        
        view.addSubview(profileImageView)
        view.addSubview(uploadButton)
        
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        uploadButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16).isActive = true
        uploadButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        uploadButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor, constant: 0).isActive = true
        
        // set profile image
        profileImageView.image = UIImage(named: "hulk")
    }
    
    // MARK: - Upload image data to server
    func uploadImage() {
        guard let url = URL(string: REGISTER_URL) else { return }
        
        // generate random boundary
        let boundary = UUID().uuidString
        
        // filename
        let fileName = "photo\(arc4random()).jpg"
        
        let image = UIImage(named: "black-widow")
        let fullNameValue = "Swathi Ganeshan"
        let emailValue = "swathi@srr.com"
        let usernameValue = "swathi"
        let passwordValue = "swathi"
        let uploadData = (image?.jpegData(compressionQuality: 0.7))!
        
        var body = Data()
        //        body = GenerateImageBody(uploadData: uploadData, serverField: "profile_image_url", boundary: boundary, fileName: fileName).getBody()
        
        body.append("\r\n--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"username\"\r\n\r\n")
        body.append("\(usernameValue)")
        
        body.append("\r\n--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"password\"\r\n\r\n")
        body.append("\(passwordValue)")
        
        body.append("\r\n--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n")
        body.append("\(emailValue)")
        
        body.append("\r\n--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"full_name\"\r\n\r\n")
        body.append("\(fullNameValue)")
        
        API.requestHttpHeaders.setValue(value: "multipart/form-data; boundary=\(boundary)", forKey: "Content-Type")
        API.requestHttpHeaders.setValue(value: "attachement; filename=\(fileName)", forKey: "Content-Disposition")
        API.requestHttpHeaders.setValue(value: "\(body.count)", forKey: "Content-Length")
//        API.httpBody = body
        API.makeRequest(toURL: url, withHttpMethod: .post) { (res) in
            if let error = res.error {
                print(error.localizedDescription)
            }
            
            if let response = res.response {
                print(response.httpStatusCode)
            }
            
            if let data = res.data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }
        }
    }
    
    
    // MARK: - Login
    func login() {
        guard let url = URL(string: LOGIN_URL) else { return }
        
        API.requestHttpHeaders.setValue(value: "application/json", forKey: "Content-Type")
        API.httpBodyParameters.setValue(value: "hulk", forKey: "username")
        API.httpBodyParameters.setValue(value: "hulk123", forKey: "password")
        
        API.makeRequest(toURL: url, withHttpMethod: .post) { (res) in
            if let error = res.error {
                print(error.localizedDescription)
            }
            
            if let statusCode = res.response {
                print(statusCode.httpStatusCode)
            }
            
            guard let data = res.data else { return }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                let dict = jsonResponse as! Dictionary<String, AnyObject>
                
                if let token = dict["token"] {
                    let auth_token = token as! String
                    do {
                        try self.keyChain.set(auth_token, key: "auth_token")
                    } catch let error{
                        print(error)
                    }
                } else {
                    print(dict)
                }
            } catch let error{
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Get some data from the server
    func getSomething() {
        guard let url = URL(string: "http://localhost:8000/boring/users/6/") else { return }
        API.makeRequest(toURL: url, withHttpMethod: .get) { (res) in
            
            if let error = res.error {
                print(error.localizedDescription)
            }
            
            if let statusCode = res.response {
                print(statusCode.httpStatusCode)
            }
            
            guard let data = res.data else { return }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                let dict = jsonResponse as! Dictionary<String, AnyObject>
                
                let profileData = dict["profile"] as! Dictionary<String, AnyObject>
                
                API.getData(fromURL: URL(string: profileData["avatar"] as! String)!, completion: { (data) in
                    guard let data = data else { return }
                    
                    DispatchQueue.main.async {
                        self.profileImageView.image = UIImage(data: data)
                        //                        self.userNameLabel.text = dict["username"] as? String
                    }
                })
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func handleUpload() {
        let token = try? keyChain.get("auth_token")
        
//        API.httpBody = nil
        guard let logoutUrl = URL(string: LOGOUT_URL) else { return }
        
        API.requestHttpHeaders.setValue(value: "Token \(token!)", forKey: "Authorization")

        // first delete the token from the server
        API.makeRequest(toURL: logoutUrl, withHttpMethod: .delete) { (res) in
            if let error = res.error {
                print(error.localizedDescription)
            }
            
            if let response = res.response {
                print(response.httpStatusCode)
            }
            
            // delete the token from the keychain
            self.keyChain["auth_token"] = nil
            
            DispatchQueue.main.async {
                let loginVC = LoginVC()
                self.present(loginVC, animated: true, completion: nil)
//                self.dismiss(animated: true, completion: nil)
            }
            print("Logout Successful...")
        }
    }
}

