//
//  FriendService.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation
import RealmSwift

final class FriendService {

    private let session: URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()

    ///  функция добавления друзей
    func loadFriends(completion: @escaping ([FriendsData]) -> Void) {
    
        /// параметры для отображения
        let params: [String: String] = [
            "v" : "5.131",
            "order": "hints",
            "fields": "photo_100, first_name, last_name",
            "access_token": Session.shared.token
        ]

        guard Session.shared.token != "" else { return }
        
        let url: URL = .configureUrl(token: Session.shared.token,
                                     method: Constants.Service.Paths.friendsGet,
                                     params: params)
        
        session.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(FriendsRequest.self, from: data)
                completion(result.response.items)
            } catch {
                print(error)
            }
        }.resume()
    }
}

