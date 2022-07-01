//
//  FriendsCollectionViewCell.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import UIKit

class FriendsCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Init
    @IBOutlet weak var likeControl: LikeControl!
    @IBOutlet weak var friendsPhotoImage: UIImageView!
    @IBOutlet weak var likeStackView: LikeControl!
    
    var markedAsLiked: ((Bool) -> Void)?
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Avatar form in the user profile
        friendsPhotoImage.layer.cornerRadius = 30
        friendsPhotoImage.contentMode = .scaleAspectFill
        friendsPhotoImage.layer.masksToBounds = true
        
        likeControl.addTarget(self, action: #selector(likeControlTapped), for: .touchUpInside)
    }
    
    //MARK: - Methods
    @objc func likeControlTapped() {
        likeControl.isSelected = !likeControl.isSelected
        markedAsLiked?(likeControl.isSelected)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [ UIImageView.AnimationOptions.allowUserInteraction, .curveEaseInOut],
                       animations: {
            self.likeControl.likeView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)

        }) { _ in
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: [ UIImageView.AnimationOptions.allowUserInteraction, .curveEaseInOut],
                           animations: {
                self.likeControl.likeView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })

        }
    }
}
