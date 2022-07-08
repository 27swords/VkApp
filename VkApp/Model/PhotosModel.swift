//
//  PhotosModel.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation
import RealmSwift

struct PhotosRequest: Decodable {
    let response: ResponsePhotos
}

struct ResponsePhotos: Decodable {
    let items: [PhotosData]

}

final class PhotosData: Object, Decodable {

    @objc dynamic var id: Int = 0
    @objc dynamic var ownerID: Int = 0
    var sizes = List<Size>()
    @objc dynamic var likes: Likes?
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case sizes = "sizes"
        case likes
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.ownerID = try container.decodeIfPresent(Int.self, forKey: .ownerID) ?? 0
        self.sizes = try container.decode(List<Size>.self, forKey: .sizes)
    }
}

final class Likes: Object, Decodable {
    @objc dynamic var likesCounter: Int = 0
    @objc dynamic var isLiked: Int = 0

    enum LikeCount: String, CodingKey {
        case likesCounter = "count"
        case isLiked = "user_likes"
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: LikeCount.self)
        self.likesCounter = try values.decodeIfPresent(Int.self, forKey: .likesCounter) ?? 0
        self.isLiked = try values.decodeIfPresent(Int.self, forKey: .isLiked) ?? 0
    }
}

final class Size: Object, Decodable {

    @objc dynamic var height: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var width: Int = 0
}
