//
//  PhotosModel.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation


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
    let ownerID: Int?
    var sizes: [Size]
    
    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case id = "id"
        case ownerID = "owner_id"
        case sizes = "sizes"
    }
}

struct Size: Codable {

    let height: Int
    let url: String
    let type: String
    let width: Int 
}
