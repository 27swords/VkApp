//
//  GroupsModel.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation


struct GroupsModel: Codable {
    var response: ResponseGroups
}

struct ResponseGroups: Codable {
    var items: [GroupData]
}

struct GroupData: Codable {
    
    let id: Int = 0
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

