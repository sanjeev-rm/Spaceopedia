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
    @IBOutlet weak var planetsAndMoonsImagesBackButton: UIButton!
    
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
            enableApodBackButton()
        case .likedApodView:
            enableLikedApodBackButton()
        case .planetsAndMoonsImagesView:
            enablePlanetsAndMoonsImagesBackButton()
        }
    }
    
    func enableApodBackButton() {
        apodBackButton.isEnabled = true
        likedApodBackButton.isEnabled = false
        planetsAndMoonsImagesBackButton.isEnabled = false
        
        apodBackButton.isHidden = false
        likedApodBackButton.isHidden = true
        planetsAndMoonsImagesBackButton.isHidden = true
    }
    
    func enableLikedApodBackButton() {
        apodBackButton.isEnabled = false
        likedApodBackButton.isEnabled = true
        planetsAndMoonsImagesBackButton.isEnabled = false
        
        apodBackButton.isHidden = true
        likedApodBackButton.isHidden = false
        planetsAndMoonsImagesBackButton.isHidden = true
    }
    
    func enablePlanetsAndMoonsImagesBackButton() {
        apodBackButton.isEnabled = false
        likedApodBackButton.isEnabled = false
        planetsAndMoonsImagesBackButton.isEnabled = true
        
        apodBackButton.isHidden = true
        likedApodBackButton.isHidden = true
        planetsAndMoonsImagesBackButton.isHidden = false
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
