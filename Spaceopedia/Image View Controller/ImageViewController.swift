//
//  ImageViewController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 07/05/23.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage?
    
    // MARK: Specific buttons for the specific source views.
    // Source views are views that has called/initiated this view controller.
    @IBOutlet weak var apodBackButton: UIButton!
    @IBOutlet weak var likedApodBackButton: UIButton!
    
    /// The Source view that has called/initiated the imageViewController.
    var sourceView: SourceToImageView = .apodView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        if let image = image {
            imageView.image = image
        }
        
        // Enabling and Denabling the buttons respectively.
        switch sourceView {
        case .apodView:
            apodBackButton.isEnabled = true
            apodBackButton.isHidden = false
            likedApodBackButton.isEnabled = false
            likedApodBackButton.isHidden = true
        case .likedApodView:
            likedApodBackButton.isEnabled = true
            likedApodBackButton.isHidden = false
            apodBackButton.isEnabled = false
            apodBackButton.isHidden = true
        }
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
