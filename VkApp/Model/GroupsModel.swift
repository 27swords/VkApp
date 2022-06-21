//
//  GroupsModel.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation
import RealmSwift


struct GroupsModel: Codable {
    let response: ResponseGroups
}

struct ResponseGroups: Codable {
    let items: [GroupData]
}

struct GroupData: Codable {
    
    let id: Int 
    let name: String
    let type: TypeEnum
    let photo100: String
    
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

//MARK: - Realm Data
class GroupDataRealm: Object, Codable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    var type: TypeEnum
    @objc dynamic var photo100: String = ""
}
