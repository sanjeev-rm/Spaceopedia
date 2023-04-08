//
//  LikeButton.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 08/04/23.
//

import UIKit

class LikeButton: UIButton {
    
    let unlikedImage: UIImage = UIImage(systemName: "suit.heart")!.applyingSymbolConfiguration(.init(scale: .large))!
    let likedImage: UIImage = UIImage(systemName: "suit.heart.fill")!.applyingSymbolConfiguration(.init(scale: .large))!
    
    var isLiked: Bool = false {
        didSet {
            if isLiked {
                self.setImage(likedImage, for: .normal)
            } else {
                self.setImage(unlikedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.setImage(unlikedImage, for: .normal)
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isLiked = !isLiked
        }
    }
}
