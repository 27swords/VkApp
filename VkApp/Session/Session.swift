//
//  Session.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation

// Singleton
final class Session {
    
    static let shared = Session()
    
    private init() {}
    
    // Access token
    var token: String?
    var userID: Int?
}
