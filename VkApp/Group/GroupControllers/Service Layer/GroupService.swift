//
//  GroupService.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation
//import RealmSwift

final class GroupService {
    typealias GroupResult = Result<[GroupData], Constants.Service.ServiceError>

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        return session
    }()

    func loadGroups(completion: @escaping (GroupResult) -> ()) {
        guard let token = Session.shared.token else {
            return completion(.failure(.notConfigureURL))
        }

        let params: [String: String] = [
            "extended" : "1",
            "v" : "5.131"
        ]

        do {
            let url: URL = try .configureUrl(token: token,
                                             method: .groupsGet,
                                             params: params)
            
            var request = URLRequest(url: url)
            
            request.httpMethod = Constants.Service.get.rawValue
            
            session.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                let decoder = JSONDecoder()
                
                do {
                    let result = try decoder.decode(GroupsModel.self, from: data)
                    completion(.success(result.response.items))
                    
                } catch {
                    
                    completion(.failure(.parseError))
                }
            }.resume()
        } catch {
            completion(.failure(.notConfigureURL))
        }
    }
    
//    ///  Метод сохранения групп
//    func saveGroupData(_ groups: [GroupsModel]) {
//
//        do {
//
//            let realm = try Realm()
//
//            realm.beginWrite()
//            realm.add(groups)
//
//            try realm.commitWrite()
//
//        } catch {
//
//            print(error)
//        }
//    }
}

