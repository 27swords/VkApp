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
    func loadFriends() {
    
        /// параметры для отображения
        let params = [
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
                let result = try JSONDecoder().decode(FriendsResponse.self, from: data).response.items
                DispatchQueue.main.async {
                    self.saveFriends(result)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

private extension FriendService {
    func saveFriends(_ friends: [FriendsData]) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL ?? "")
            try realm.write {
                realm.add(friends, update: .modified)
            }
        } catch {
            print("DBG", error)
        }
    }
}
