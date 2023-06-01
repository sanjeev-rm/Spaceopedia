//
//  SpacePicTableViewCell.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 01/06/23.
//

import UIKit

class SpacePicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var spacePicImageView: UIImageView!
    @IBOutlet weak var spacePicDescriptionLabel: UILabel!
    @IBOutlet weak var spacePicCopyrightLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
