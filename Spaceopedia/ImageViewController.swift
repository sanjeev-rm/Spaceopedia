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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        if let image = image {
            imageView.image = image
        }
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
