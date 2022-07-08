//
//  RealmCacheService.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 6.07.22.
//

import Foundation
import RealmSwift

final class RealmCacheService {
    func create<T: Object>(_ object: T) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object)
            }
        } catch {
            print(error)
        }
    }

    func create<T: Object>(_ object: [T]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object)
            }
        } catch {
            print(error)
        }
    }

    func read<T: Object>(_ object: T.Type) -> Results<T> {
            let realm = try! Realm()
            return realm.objects(object)
    }
}

