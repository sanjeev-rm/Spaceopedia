//
//  SpaceNewsArticleTableViewCell.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 06/06/23.
//

import UIKit

class SpaceNewsArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// Function updates all the cell components.
    func update(image: UIImage? = nil, title: String, copyright: String?) {
        articleImageView.image = image
        titleLabel.text = title
        copyrightLabel.text = copyright
    }
    
    /// Function updates the cell with the given image.
    func updateWith(image: UIImage?) {
        articleImageView.image = image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
