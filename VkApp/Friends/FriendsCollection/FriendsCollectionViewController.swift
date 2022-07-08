//
//  FriendsCollectionViewController.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import UIKit
import RealmSwift

struct PhotoTestData {
    let name: String
    var isLiked: Bool = false
}

class FriendsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Init
    var frinedsIndex: Int = 0
    var photoOwnerID: Int?
    
    private let photoService = PhotoFriendsService()
    var photoData: PhotosData?
    var userId: Int = 0
    var storedImages = [String]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhoto()
    }
    
    //MARK: - Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  storedImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? FriendsCollectionViewCell
        
        cell?.friendsPhotoImage.loadImage(with: storedImages[indexPath.item])
                
//        cell?.likeControl.isSelected = photoData[indexPath.item].likes?.isLiked == 1 ? true : false
//        cell?.likeControl.likesCounter = photoData[indexPath.item].likes?.likesCounter ?? 0
//
//        cell?.markedAsLiked = { [weak self] isSelected in
//            self?.photoData[indexPath.item].likes?.isLiked = isSelected ? 1 : 0
//        }
        
        
        return cell ?? UICollectionViewCell()
    }
}

extension FriendsCollectionViewController {
    func loadPhoto() {
        
        Task {
            try await photoService.loadPhotoVK(for: userId)
            await loadRealmData()
            collectionView.reloadData()
        }
    }

    func loadRealmData() async {
        do {
            let realmDB = try await Realm()
            realmDB.objects(PhotosData.self)
                .where { $0.ownerID == userId }
                .forEach { friends in
                    self.photoData = friends
                }
        } catch let error as NSError {
            print("Realm Objects Error: \(error.localizedDescription)")
        }
    }
}
