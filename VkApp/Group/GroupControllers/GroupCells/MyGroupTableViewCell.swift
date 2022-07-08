//
//  MyGroupTableViewCell.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import UIKit

class MyGroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photosMyGroupImage: UIImageView!
    @IBOutlet weak var myGroupLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCellForGroup(_ group: GroupData) {
        myGroupLabel.text = group.name
        photosMyGroupImage.loadImage(with: group.photo100)
    }
}
