//
//  PhotoFriendsService.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import Foundation
import RealmSwift

final class PhotoFriendsService {

    private let session: URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()
    
    /// функция добавления фотографий пользователя
    func loadPhotoVK(for id: String, completion: @escaping ([PhotosData]) -> Void) async {

        // параметры фотографий
        let params: [String: String] = [
            "owner_id" : "\(id)",
            "v" : "5.131",
            "access_token": Session.shared.token,
            "extended" : "0"
        ]
        
        guard Session.shared.token != "" else  { return }
        
        let url: URL = .configureUrl(token: Session.shared.token,
                                     method: Constants.Service.Paths.photosGet,
                                     params: params)
        print("DBG", url)
        
        do {
            let (data, _) = try await session.data(from: url)
            let decoder = JSONDecoder()
            let result = try decoder.decode(PhotosRequest.self, from: data).response.items
            completion(result)
        } catch {
            print(error)
        }
    }
}

//MARK: - Extensions
private extension PhotoFriendsService {

    ///  Метод сохранения фотографий
    func savePhotosData(photos: [PhotosData]) {
        if let realm = try? Realm() {
            print(realm.configuration.fileURL ?? "")
            do {
                try realm.write({
                    realm.add(photos, update: .modified)
                })
            } catch {
                print("error")
            }
        }
    }
}

