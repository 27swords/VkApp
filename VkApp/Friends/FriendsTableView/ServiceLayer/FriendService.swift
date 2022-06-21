//
//  FriendService.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation
//import RealmSwift

class FriendService {
    typealias FriendsResult = Result<[FriendsData], Constants.Service.ServiceError>

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()

    ///  функция добавления друзей
    func loadFriends(completion: @escaping (FriendsResult) -> ()) {
        guard let token = Session.shared.token else {
            return completion(.failure(.notConfigureURL))
        }

        /// параметры для отображения
        let params: [String: String] = [
            "v" : "5.131",
            "fields": "photo_100"
        ]

        do {
            let url: URL = try .configureUrl(token: token,
                                             method: .friendsGet,
                                             params: params)
            
            var request = URLRequest(url: url)
            
            request.httpMethod = Constants.Service.get.rawValue
            
            session.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                let decoder = JSONDecoder()
                
                do {
                    let result = try decoder.decode(FriendsModel.self, from: data)
                    completion(.success(result.response.items))
                    
                } catch {
                    completion(.failure(.parseError))
                }
            }.resume()
        } catch {
            completion(.failure(.notConfigureURL))
        }
    }
}

//extension FriendService {
//
//    ///  Метод сохранения друзей
//    func saveFriendsData(_ friends: [FriendsModel]) {
//
//        do {
//
//            let realm = try Realm()
//
//            realm.beginWrite()
//            realm.add(friends)
//
//            try realm.commitWrite()
//
//        } catch {
//
//            print(error)
//        }
//    }
//
//}
