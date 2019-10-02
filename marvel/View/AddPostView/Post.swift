//
//  Post.swift
//  marvel
//
//  Created by Shree Ranga Raju on 2019-09-20.
//  Copyright © 2019 Shree Ranga Raju Inc. All rights reserved.
//

import Foundation

struct Post: Codable {
    let id: Int
    let imageUrl: String?
    let caption: String?
    let owner: User?
    var likesCount: Int?
    let creationDate: String?
//    var didCurrentUserLike: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case imageUrl = "post_image"
        case caption = "caption"
        case owner = "owner"
        case likesCount = "likes_count"
        case creationDate = "created_at"
    }
}
