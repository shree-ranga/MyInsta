//
//  CustomImageView.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-17.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import UIKit

var imageNSCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
//    var imageCache = [String: UIImage]()

    private var lastURLUsedToLoadImage: String?
    
    func loadImage(with urlString: String) {
        
        let urlString = BASE_URL + urlString
        
        lastURLUsedToLoadImage = urlString
        image = nil
        
        if let cachedImage = imageNSCache.object(forKey: urlString as NSString) {
            image = cachedImage
            return
        }
        
//        if let cachedImage = imageCache[urlString] {
//            image = cachedImage
//            return
//        }
        
        guard let url = URL(string: urlString) else { return }
        
        API.getData(fromURL: url, completion: { (data) in
            if url.absoluteString != self.lastURLUsedToLoadImage { return }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
//            self.imageCache[url.absoluteString] = photoImage
            imageNSCache.setObject(photoImage!, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
        })
    }
}
