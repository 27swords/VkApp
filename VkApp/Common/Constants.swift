//
//  Constants.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation

struct Constants {

    enum Service: String, CaseIterable {
        
        enum Paths: String, CaseIterable {
            case friendsGet = "/method/friends.get"
            case groupsGet = "/method/groups.get"
            case photosGetAll = "/method/photos.getAll"
            
        }
        
        enum ServiceError: Error {
            case parseError
            case notConfigureURL
            case requestError(Error)
        }

        case scheme = "https"
        case host = "api.vk.com"
        case get = "GET"
        case post = "POST"
    }
}
