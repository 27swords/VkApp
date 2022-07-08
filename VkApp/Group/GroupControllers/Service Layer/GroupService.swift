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

    func loadGroups() {
        
        let params = [
            "extended" : "1",
            "v" : "5.131",
            "access_token": Session.shared.token
        ]

        guard Session.shared.token != "" else { return }
        
        let url: URL = .configureUrl(token: Session.shared.token,
                                     method: Constants.Service.Paths.groupsGet,
                                     params: params)
        print("DBG", url)
        
        session.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(GroupsResponse.self, from: data).response.items
                DispatchQueue.main.async {
                    self.saveGroups(result)
                }
            } catch {
                print("DBG parseError", Constants.Service.ServiceError.parseError)
            }
        }.resume()
    }
}

private extension GroupService {
    func saveGroups(_ groups: [GroupData]) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL ?? "")
            try realm.write {
                realm.add(groups, update: .modified)
            }
        } catch {
            print("DBG", error)
        }
    }
}
