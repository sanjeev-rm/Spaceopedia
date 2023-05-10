//
//  DiscloseButton.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 10/05/23.
//

import UIKit

class DiscloseButton: UIButton {
    
    let discloseImage: UIImage = UIImage(systemName: "chevron.down")!.applyingSymbolConfiguration(.init(scale: .medium))!.withTintColor(.systemGray2, renderingMode: .alwaysOriginal)
    let unDiscloseImage: UIImage = UIImage(systemName: "chevron.up")!.applyingSymbolConfiguration(.init(scale: .medium))!.withTintColor(.systemGray2, renderingMode: .alwaysOriginal)
    
    var isDisclosed: Bool = false {
        didSet {
            if isDisclosed {
                self.setImage(unDiscloseImage, for: .normal)
            } else {
                self.setImage(discloseImage, for: .normal)
            }
        }
    }
    
    func toggleIsDisclosed() {
        isDisclosed.toggle()
    }
    
//    override func awakeFromNib() {
//        self.setImage(discloseImage, for: .normal)
//        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
//    }
//
//    @objc func buttonClicked(sender: UIButton) {
//        if sender == self {
//            isDisclosed = !isDisclosed
//        }
//    }
}
