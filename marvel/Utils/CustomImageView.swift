//
//  CustomImageView.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-17.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {

    private var lastURLUsedToLoadImage: String?
    
    func loadImage(with urlString: String) {
        
        let urlString = BASE_URL + urlString
        
        lastURLUsedToLoadImage = urlString
        image = nil
        
        if let cachedImage = imageCache[urlString] {
            image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        API.getData(fromURL: url, completion: { (data) in
            if url.absoluteString != self.lastURLUsedToLoadImage { return }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
        })
    }
}
