//
//  LikedTableViewCell.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 08/04/23.
//

import UIKit

class LikedTableViewCell: UITableViewCell {

    @IBOutlet weak var apodImageView: UIImageView!
    
    @IBOutlet weak var apodTitleLabel: UILabel!
    
    @IBOutlet weak var apodDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(image: UIImage, title: String, date: Date)
    {
        self.apodImageView.image = image
        self.apodTitleLabel.text = title
        self.apodDateLabel.text = "\(date.description.prefix(10))"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
