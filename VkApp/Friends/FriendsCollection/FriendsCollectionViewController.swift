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
    var photoData = [PhotosData]()
    var userId: String = ""
    var storedImages = [String]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhoto()
    }
    
    //MARK: - Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storedImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? FriendsCollectionViewCell
        
        cell?.friendsPhotoImage.loadImage(with: storedImages[indexPath.item])
        cell?.likeControl.isSelected = photoData[indexPath.item].likes?.isLiked == 1 ? true : false
        cell?.likeControl.likesCounter = photoData[indexPath.item].likes?.likesCounter ?? 0
        
        cell?.markedAsLiked = { [weak self] isSelected in
            self?.photoData[indexPath.item].likes?.isLiked = isSelected ? 1 : 0
        }
        
        
        return cell ?? UICollectionViewCell()
    }
}

extension FriendsCollectionViewController {
    func loadPhoto() {
        Task {
            await photoService.loadPhotoVK(for: userId) { [weak self] photos in
                self?.photoData = photos
                if let imageLInks = self?.sortImage(type: "w", array: photos) {
                    self?.storedImages = imageLInks
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func sortImage(type: String, array: [PhotosData]) -> [String] {
        var links = [String]()

        for model in array {
            for size in model.sizes {
                if size.type == type {
                    links.append(size.url)
                }
            }
        }
        return links
    }
}
