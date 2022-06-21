//
//  FriendsModel.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation
//import RealmSwift

class FriendsModel: Codable {
    
    var response: ResponseFriends
}

struct ResponseFriends: Codable {

    let count: Int
    var items: [FriendsData]
}

struct FriendsData: Codable {

    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo100 = "photo_100"
    }
}
