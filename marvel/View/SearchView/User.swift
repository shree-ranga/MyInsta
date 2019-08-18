//
//  User.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-18.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import Foundation

struct User: Codable {
    var id: Int
    var userName: String
    var fullName: String
    var profileImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userName = "username"
        case fullName = "full_name"
        case profileImageUrl = "profile_image_url"
    }
}

