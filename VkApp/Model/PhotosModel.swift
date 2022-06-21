//
//  PhotosModel.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation
import RealmSwift

struct PhotosModel: Codable {
    
    var response: ResponsePhotos
}

struct ResponsePhotos: Codable {
    
    let count: Int
    let items: [PhotosData]
    
}

struct PhotosData: Codable {

    let albumID: Int
    let id: Int
    let ownerID: Int
    let sizes: [Size]
    
    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case id = "id"
        case ownerID = "owner_id"
        case sizes = "sizes"
    }
}

class Size: Object, Codable {

    let height: Int
    let url: String
    let type: String
    let width: Int
}

//MARK: - Realm Data
class PhotosDataRealms: Object, Codable {
    
    @objc dynamic var albumID: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerID: Int = 0
    var sizes: List<Size>
}
