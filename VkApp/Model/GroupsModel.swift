//
//  GroupsModel.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation
import RealmSwift


struct GroupsResponse: Decodable {
    let response: GroupsItems
}

struct GroupsItems: Decodable {
    let items: [GroupData]
}

class GroupData: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photo100: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case photo100 = "photo_100"
    }
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.photo100 = try container.decodeIfPresent(String.self, forKey: .photo100) ?? ""

    }
}
