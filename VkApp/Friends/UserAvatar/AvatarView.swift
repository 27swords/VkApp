//
//  AvatarView.swift
//  VkApp
//
//  Created by Alexander Chervoncev on 21.06.22.
//

import UIKit

class AvatarView: UIView {
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.setFillColor(UIColor.clear.cgColor)

        let path = UIBezierPath(roundedRect: rect, cornerRadius: 50)
        path.fill()
    }
}
