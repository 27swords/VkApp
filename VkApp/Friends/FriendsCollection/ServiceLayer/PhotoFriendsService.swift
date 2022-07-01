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
    func loadPhotoVK(for id: Int) async throws {

        // параметры фотографий
        let params: [String: String] = [
            "owner_id" : "\(id)",
            "v" : "5.131",
            "access_token": Session.shared.token,
            "extended" : "1"
        ]
        
        guard Session.shared.token != "" else  { return }
        
        let url: URL = .configureUrl(token: Session.shared.token,
                                     method: Constants.Service.Paths.photosGetAll,
                                     params: params)
        print("DBG", url)
        
        let request = URLRequest(url: url)
        do {
            let (data, _) = try await session.data(for: request)
            let decoder = JSONDecoder()
            let result = try decoder.decode(PhotosData.self, from: data)//.response.items
            await savePhotosData(photos: result)
        }
    }
}

//MARK: - Extensions
private extension PhotoFriendsService {

    ///  Метод сохранения фотографий
    func savePhotosData(photos: PhotosData) async {
        if let realm = try? await Realm() {
            print(realm.configuration.fileURL ?? "")
            do {
                try realm.write {
                    realm.add(photos, update: .modified)
                }
            } catch let error as NSError {
                print("Error Realm: \(error.localizedDescription) ")
            }
        }
    }
}

