//
//  User.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-08-18.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import Foundation
import KeychainAccess

struct User: Codable {
    let keyChain = Keychain(server: BASE_URL, protocolType: .http)
    var id: Int
    var userName: String
    var fullName: String
    var profileImageUrl: String?
    var bio: String?
    var numberOfFollowers: Int?
    var numberOfFollowing: Int?
    var isLoggedInUserFollowing: Bool!
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userName = "username"
        case fullName = "full_name"
        case profileImageUrl = "profile_image_url"
        case bio = "bio"
        case numberOfFollowers = "total_followers"
        case numberOfFollowing = "total_following"
    }
}




