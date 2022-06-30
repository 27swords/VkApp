//
//  GroupService.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation
import RealmSwift

class GroupService {

    private let session: URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()

    func loadGroups(completion: @escaping ([GroupData]) -> Void) {
        
        let params = [
            "extended" : "1",
            "v" : "5.131",
            "access_token": Session.shared.token
        ]

        guard Session.shared.token != "" else { return }
        
        let url: URL = .configureUrl(token: Session.shared.token,
                                     method: Constants.Service.Paths.groupsGet,
                                     params: params)
        
        session.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(GroupsRequest.self, from: data)
                completion(result.response.items)
            } catch {
                print(error)
            }
        }.resume()
    }
}


