//
//  LikedApodTableViewController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 14/04/23.
//

import UIKit
import youtube_ios_player_helper

/// This represents an Error model for the Liked Apod VC.
/// When creating an instance of this VC and there's an error instead of an APOD then you can create an error of this type.
/// And set the optional parameter of this type in the VC. So that the UI of this VC updates with respect to this LikedApodError instance given.
struct LikedApodError
{
    var title: String?
    var message: String?
}

class LikedApodTableViewController: UITableViewController, YTPlayerViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var likeButton: LikeButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var copyrightLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet var videoPlayerView: YTPlayerView!
    
    var likedApod: LikedApod?
    
    var apodImage: UIImage?
    
    /// The likedApodError used to update the UI with custom error title and message.
    /// Only updates UI with this when the VC loads and the likedApod property is nil.
    var likedApodError: LikedApodError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let likedApod = likedApod {
            do {
                try updateUI(apod: likedApod.apod)
            } catch {
                updateUI(error: error)
            }
        } else if let likedApodError = likedApodError {
            updateUIWithError(likedApodError: likedApodError)
        } else {
            updateUIWithError(likedApodError: LikedApodError())
        }
    }
    
    //MARK: - Functions
    
    /// Initial updates to the UI for when the app is fetching APOD from the NASA API.
    func fetchingApodViewUpdate()
    {
        imageView.isHidden = true
        imageViewButton.isHidden = true
        videoPlayerView.isHidden = true
        titleLabel.text = "Fetching Apod..."
        descriptionTextView.text = ""
        likeButton.isEnabled = false
        likeButton.isHidden = true
        copyrightLabel.text = ""
        shareButton.isEnabled = false
        shareButton.isHidden = true
    }
    
    /// Updates the UI with an APOD.
    /// Throws when there's errors in fetching the image.
    func updateUI(apod: Apod) throws
    {
        Task {
            if apod.mediaType == "image" {
                imageView.image = try await ApodController.fetchApodImage(imageUrl: apod.url)
                imageView.isHidden = false
                imageViewButton.isHidden = false
                videoPlayerView.isHidden = true
            } else if apod.mediaType == "video" {
                videoPlayerView.load(withVideoId: "\(apod.url.lastPathComponent)") // .lastPathComponent gives us the youtube video ID.
                videoPlayerView.delegate = self
                videoPlayerView.isHidden = false
                imageView.isHidden = true
                imageViewButton.isHidden = true
            }
            titleLabel.text = apod.title
            descriptionTextView.text = apod.description
            likeButton.isEnabled = true
            likeButton.isHidden = false
            likeButton.isLiked = ApodController.likedApods!.contains(where: {$0.apod == apod})
            if let copyright = apod.copyright {
                copyrightLabel.text = "©\(copyright)"
            }
            shareButton.isEnabled = true
            shareButton.isHidden = false
        }
    }
    
    /// Updates the UI with an error.
    /// Used when there's an error.
    func updateUI(error: Error)
    {
        imageView.isHidden = true
        imageViewButton.isHidden = true
        videoPlayerView.isHidden = true
        titleLabel.text = "Could not fetch Apod...🫤"
        descriptionTextView.text = "# Check the wifi connection.\n# Try another date.\nIf still not working try again after an hour.\nIf not, try tommorow."
        likeButton.isEnabled = false
        likeButton.isHidden = true
        copyrightLabel.text = ""
        shareButton.isEnabled = false
        shareButton.isHidden = true
    }
    
    /// Updates the UI with custom error title and message.
    /// Used for when an unfortunate error occurs.
    func updateUIWithError(likedApodError: LikedApodError)
    {
        imageView.isHidden = true
        imageViewButton.isHidden = true
        videoPlayerView.isHidden = true
        titleLabel.text = likedApodError.title != nil ? likedApodError.title : "Error..."
        descriptionTextView.text = likedApodError.message != nil ? likedApodError.message : "There seems to be an error."
        likeButton.isEnabled = false
        likeButton.isHidden = true
        copyrightLabel.text = ""
        shareButton.isEnabled = false
        shareButton.isHidden = true
    }
    
    // MARK: - Action functions
    
    @IBAction func likeButtonTapped(_ sender: LikeButton)
    {
        if sender.isLiked {
            // Means that the button that sent this function was liked but after clicking it must be removed.
            // Therefore removed.
            if let likedApod = likedApod,
               let apodPresentAt = ApodController.likedApods?.firstIndex(where: { $0.apod == likedApod.apod }),
               var likedApods = ApodController.likedApods {
                likedApods.remove(at: apodPresentAt)
                ApodController.saveLikedApodsToFile(apods: likedApods)
            }
        } else {
            // Means that the button that sent this function was not liked but after clicking it must be likd and added to the likedApods list.
            // Therefore added to the list.
            if let likedApod = likedApod,
               var likedApods = ApodController.likedApods {
                likedApods.append(likedApod)
                ApodController.saveLikedApodsToFile(apods: likedApods)
            }
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton)
    {
        guard let likedApod = likedApod else { return }
        
        let mediaUrl = likedApod.apod.url
        let description = likedApod.apod.description
        
        var activityItems: [Any]
        if let image = imageView.image {
            activityItems = [image, description]
        } else {
            activityItems = [mediaUrl, description]
        }
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    // MARK: - Functions from YTPlayerViewDelegate
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        videoPlayerView.playVideo()
    }
    
    // MARK: - Segue Action function
    @IBSegueAction func imageViewSegue(_ coder: NSCoder, sender: Any?) -> ImageViewController? {
        
        let imageVC = ImageViewController(coder: coder)
        if let image = imageView.image {
            imageVC?.image = image
        }
        return imageVC
    }
    
    // MARK: - Unwind function
    
    @IBAction func unwindToLikedApodView(unwindSegue: UIStoryboardSegue) {
    }
}
