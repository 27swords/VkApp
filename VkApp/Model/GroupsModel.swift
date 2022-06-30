//
//  GroupsModel.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation
import RealmSwift


struct GroupsRequest: Decodable {
    let response: ResponseGroups
}

struct ResponseGroups: Decodable {
    let items: [GroupData]
}

class GroupData: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    var type: TypeEnum?
    @objc dynamic var photo100: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "name"
        case type = "type"
        case photo100 = "photo_100"
    }
}

enum TypeEnum: String, Codable {
    case group = "group"
    case page = "page"
}

