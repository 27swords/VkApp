//
//  LikeControl.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import UIKit

class LikeControl: UIControl {

    @IBOutlet weak var likeView: UIImageView?
    @IBOutlet weak var counterLabel: UILabel?
    
    var likesCounter: Int = 0
    
    // Like clicks function
    override var isSelected: Bool {
        didSet {
            likeView?.image = isSelected ? UIImage(named: "like") : UIImage(named: "disable like")
            
            if isSelected {
                likesCounter += 1
            } else {
                likesCounter -= 1
            }
            
            counterLabel?.text = "\(likesCounter)"
        }
    }
}
