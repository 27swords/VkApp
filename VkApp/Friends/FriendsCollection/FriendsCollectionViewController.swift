//
//  FriendsCollectionViewController.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import UIKit

class FriendsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Init
    var frinedsIndex: Int = 0
    var photoOwnerID: Int?
    
    let photoService = PhotoFriendsService()
    var photoData = [PhotosData]()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let photoOwnerID = photoOwnerID else { return }
        
        photoService.loadPhotoVK(ownerID: photoOwnerID) { result in
            switch result {
            case .success(let photo):
                DispatchQueue.main.async {
                    self.photoData = photo
                    self.collectionView.reloadData()
                }
                
            case .failure(_):
                return
            }
        }
        
        
    }
    
    //MARK: - Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? FriendsCollectionViewCell
        let photoR = photoData
            .map { $0.sizes }
            .flatMap { $0 }
            .filter { $0.type == "r" }
        
        cell?.friendsPhotoImage.loadImage(with: photoR[indexPath.item].url)
        
        return cell ?? UICollectionViewCell()
    }
}
