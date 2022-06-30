//
//  Extensions+URL.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation

extension URL {
    
    static func configureUrl(token: String,
                             method: Constants.Service.Paths,
                             params: [String: String]) -> URL {
            
        var queryItems: [URLQueryItem] = []
        
        params.forEach { param, value in
            queryItems.append(URLQueryItem(name: param, value: value))
        }
        queryItems.append(URLQueryItem(name: "access_token", value: token))
        
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.Service.scheme.rawValue
        urlComponents.host = Constants.Service.host.rawValue
        urlComponents.path = method.rawValue
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { fatalError("") }
        
        return url
    }
}
