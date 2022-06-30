//
//  FriendsModel.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation
import RealmSwift

struct FriendsRequest: Decodable {

    let response: ResponseFriends
}

struct ResponseFriends: Decodable {
    let items: [FriendsData]
}

final class FriendsData: Object, Decodable {

    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var photo100: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo100 = "photo_100"
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        self.photo100 = try container.decodeIfPresent(String.self, forKey: .photo100) ?? ""
    }
}
