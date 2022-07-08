//
//  FriendsTableViewCell.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var friendsImage: UIImageView!
    @IBOutlet weak var nameFriendsLabel: UILabel!
    @IBOutlet weak var avatarCellView: AvatarView!
    
    var animator: UIViewPropertyAnimator?
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Сreating an avatar form
        friendsImage.layer.borderWidth = 1
        friendsImage.layer.masksToBounds = false
        friendsImage.layer.borderColor = UIColor.clear.cgColor
        friendsImage.layer.cornerRadius = friendsImage.frame.height / 2
        friendsImage.clipsToBounds = true

    }
    
    //MARK: - Methods
    
    func configureCellForFreind(_ friend: FriendsData) {
        nameFriendsLabel.text = friend.firstName + " " + friend.lastName
        friendsImage.loadImage(with: friend.photo100)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        avatarCellView.isUserInteractionEnabled = true
        avatarCellView.addGestureRecognizer(imageTap)
        
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: UIImageView.AnimationOptions.allowUserInteraction,
                       animations: {
            
            self.avatarCellView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.avatarCellView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.15,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0,
                           options: UIImageView.AnimationOptions.allowUserInteraction,
                           animations: {
                
                self.avatarCellView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.friendsImage.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            
        }
    }
}
