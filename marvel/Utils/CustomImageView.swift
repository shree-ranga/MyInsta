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
    
    var lastImageURLUsedToLoadImage: String?
    
    func loadImage(with urlString: String) {
        
        let urlString = BASE_URL + urlString
        
        // set image property to nil
        image = nil
        
        // set lastImageURLUsedToLoadImage
        lastImageURLUsedToLoadImage = urlString
        
        // check if image exists in cache
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        // create image url
        guard let imageUrl = URL(string: urlString) else { return }
        
        // create data task
        API.getData(fromURL: imageUrl) { (data) in
            
            //            // handle error
            //            if let error = error {
            //                print("Failed to load image", error.localizedDescription)
            //            }
            //
            if self.lastImageURLUsedToLoadImage != imageUrl.absoluteString {
                return
            }
            
            // image data
            guard let imageData = data else { return }
            
            // create image from the image data
            let photoImage = UIImage(data: imageData)
            
            // set key and value for image cache
            imageCache[imageUrl.absoluteString] = photoImage
            
            // set image
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }
    }
}

