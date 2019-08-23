//
//  SignupVC.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-06.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit
import KeychainAccess

class SignupVC: UIViewController {
    
    var signupView: SignupView!
    
    let imagePicker = UIImagePickerController()
    
    private let keyChain = Keychain(server: BASE_URL, protocolType: .http)
    
    var isImageSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        signupView.delegate = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    func setupViews() {
        signupView = SignupView(frame: UIScreen.main.bounds)
        view.addSubview(signupView)
    }
}

extension SignupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {
            isImageSelected = false
            return
        }
        
        // figure out why i need this
        isImageSelected = true
        
        // configure profile photo button with selected image
        signupView.profileImageButton.layer.cornerRadius = signupView.profileImageButton.frame.width / 2
        signupView.profileImageButton.contentMode = .scaleAspectFill
        signupView.profileImageButton.layer.masksToBounds = true
        signupView.profileImageButton.layer.borderColor = UIColor.black.cgColor
        signupView.profileImageButton.layer.borderWidth = 1
        signupView.profileImageButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}


extension SignupVC: SignupViewDelegate {
    
    func handleSelectPhoto(for view: SignupView) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func handleSignin(for view: SignupView) {
        let loginVC = LoginVC()
        present(loginVC, animated: true, completion: nil)
    }
    
    func handleSignup(for view: SignupView) {
        guard let userName = signupView.userNameTextField.text else { return }
        guard let email = signupView.emailTextField.text else { return }
        guard let fullName = signupView.fullNameTextField.text else { return }
        guard let password = signupView.passwordTextField.text else { return }
        
        if let profileImage = signupView.profileImageButton.imageView?.image {
            let uploadData = profileImage.jpegData(compressionQuality: 0.7)!
            
            let (boundary, fileName) = generateBoundaryAndFileName()
            
            var body: Data
            
            body = MultiPartFormBody(uploadData: uploadData, serverField: "profile_image_url", boundary: boundary, fileName: fileName).getBody()
            
            body.append("\r\n--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"username\"\r\n\r\n")
            body.append("\(userName.lowercased())")
            
            body.append("\r\n--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"password\"\r\n\r\n")
            body.append("\(password.lowercased())")
            
            body.append("\r\n--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"email\"\r\n\r\n")
            body.append("\(email.lowercased())")
            
            body.append("\r\n--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"full_name\"\r\n\r\n")
            body.append("\(fullName)")
            
            API.httpBody = body
            
            API.requestHttpHeaders.setValue(value: "multipart/form-data; boundary=\(boundary)", forKey: "Content-Type")
            API.requestHttpHeaders.setValue(value: "attachement; filename=\(fileName)", forKey: "Content-Disposition")
            API.requestHttpHeaders.setValue(value: "\(body.count)", forKey: "Content-Length")
        }
        else {
            API.httpBodyParameters.setValue(value: userName.lowercased(), forKey: "username")
            API.httpBodyParameters.setValue(value: fullName, forKey: "full_name")
            API.httpBodyParameters.setValue(value: password.lowercased(), forKey: "password")
            API.httpBodyParameters.setValue(value: email.lowercased(), forKey: "email")
            
            API.requestHttpHeaders.setValue(value: "application/json", forKey: "Content-Type")
        }
        
        guard let registerUrl = URL(string: REGISTER_URL) else { return }
        
        API.makeRequest(toURL: registerUrl, withHttpMethod: .post) { (results) in
            if let error = results.error {
                print(error.localizedDescription)
            }
            
            if let response = results.response {
                print(response.httpStatusCode)
            }
            
            if let data = results.data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let dict = jsonResponse as? Dictionary<String, AnyObject> else { return }
                    print(dict)
                } catch let error {
                    print(error.localizedDescription)
                }
                
                API.requestHttpHeaders.setValue(value: "application/json", forKey: "Content-Type")
                API.httpBodyParameters.setValue(value: userName.lowercased(), forKey: "username")
                API.httpBodyParameters.setValue(value: password.lowercased(), forKey: "password")
                let authTokenUrl = URL(string: REGISTER_URL + "api-auth-token/")!
                
                API.makeRequest(toURL: authTokenUrl, withHttpMethod: .post, completion: { (res) in
                    if let error = res.error {
                        print(error.localizedDescription)
                    }
                    
                    if let response = res.response {
                        print(response.httpStatusCode)
                    }
                    
                    guard let data = res.data else { return }
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    guard let dict = json as? Dictionary<String, String> else { return }
                    if let auth_token = dict["token"] {
                        try? self.keyChain.set(auth_token, key: "auth_token")
                        print("Registration Successful...")
                        
                        DispatchQueue.main.async {
                            //                            let mainVC = ViewController()
                            let mainVC = MainTabBarVC()
                            self.present(mainVC, animated: true, completion: nil)
                        }
                    } else {
                        print("Unable to register")
                    }
                })
            }
        }
    }
    
    func generateBoundaryAndFileName() -> (String, String) {
        let boundary = UUID().uuidString
        let fileName = "photo\(arc4random()).jpg"
        return (boundary, fileName)
    }
}
