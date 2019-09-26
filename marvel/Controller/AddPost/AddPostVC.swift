//
//  AddPostVC.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-16.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit
import KeychainAccess

class AddPostVC: UIViewController {
    
    var addPostView: AddPostView!
    
    var selectedImage: UIImage?
    
    let keyChain = Keychain(server: BASE_URL, protocolType: .http)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureNavBar()
        loadImage()
    }
    
    func setupViews() {
        addPostView = AddPostView(frame: UIScreen.main.bounds)
        view.addSubview(addPostView)
    }
    
    func configureNavBar() {
        navigationItem.title = "New Post"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    }
    
    func loadImage() {
        if let selectedImage = selectedImage {
            addPostView.photoImageView.image = selectedImage
        }
    }
    
    func generateBoundaryAndFileName() -> (String, String) {
        let boundary = UUID().uuidString
        let fileName = "photo\(arc4random()).jpg"
        return (boundary, fileName)
    }
    
    @objc func handleShare() {
        print("Uploading post.....")
        uploadPost()
    }
    
    // MARK: - API calls
    func uploadPost() {
        let token = try? keyChain.get("auth_token")
        
        // TODO: - handle empty caption
        guard let caption = addPostView.captionTextView.text else { return }
        guard let postImage = addPostView.photoImageView.image else { return }
        
        let uploadImageData = postImage.jpegData(compressionQuality: 0.7)!
        let (boundary, fileName) = generateBoundaryAndFileName()
        
        var body: Data
        body = MultiPartFormBody(uploadData: uploadImageData, serverField: "post_image", boundary: boundary, fileName: fileName).getBody()
        
        body.append("\r\n--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"caption\"\r\n\r\n")
        body.append("\(caption)")
        
        API.httpBody = body
        
        let url = URL(string: UPLOAD_POST_URL)!
        
        API.requestHttpHeaders.setValue(value: "Token \(token!)", forKey: "Authorization")
        API.requestHttpHeaders.setValue(value: "multipart/form-data; boundary=\(boundary)", forKey: "Content-Type")
        API.requestHttpHeaders.setValue(value: "attachement; filename=\(fileName)", forKey: "Content-Disposition")
        
        API.makeRequest(toURL: url, withHttpMethod: .post) { (res) in
            if let error = res.error {
                print(error.localizedDescription)
                return
            }
            
            if let response = res.response {
                print(response.httpStatusCode)
            }
            
            if let data = res.data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                print(json!)
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: {
                    self.tabBarController?.selectedIndex = 0
                })
            }
        }
    }
}
