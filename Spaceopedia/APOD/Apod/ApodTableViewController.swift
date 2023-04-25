//
//  ApodTableViewController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 06/04/23.
//

import UIKit

class ApodTableViewController: UITableViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var likeButton: LikeButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var copyrightLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    var apod: Apod?
    
    var likedApods: [LikedApod] = [LikedApod]()
    
    /// Instance of UIRefreshController for the pull-to-refresh functionality.
    private var pullRefresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.maximumDate = Date()
        
        fetchingApodViewUpdate()
        
        Task {
            do {
                let date = datePicker.date.description.prefix(10)
                let query = ["api_key":"DEMO_KEY", "date":"\(date)"]
                apod = try await ApodController.fetchApodInfo(query: query)
                updateUI(apod: apod!)
            } catch {
                updateUI(error: error)
            }
        }
        
        // Implementing the Pull-to-Refresh functinality.
        pullRefresh.attributedTitle = NSAttributedString("")
        pullRefresh.addTarget(self, action: #selector(pulledToRefresh(_:)), for: .valueChanged)
        tableView.addSubview(pullRefresh)
    }
    
    // MARK: - @objc action function.
    
    /// @objc sction function for the pull to refresh functionality.
    /// This is the function that is run when the user pulls to refresh the view.
    @objc func pulledToRefresh(_ sender: Any)
    {
        tableView.reloadData()
        pullRefresh.endRefreshing()
    }
    
    // MARK: - Functions
    
    /// Initial updates to the UI for when the app is fetching APOD from the NASA API.
    func fetchingApodViewUpdate()
    {
        // Gets the updated(latest) liked APODS list everytime fetching a new APOD.
        likedApods = ApodController.loadLikedApodsFromFile()
        
        imageView.isHidden = true
        titleLabel.text = "Fetching Apod..."
        descriptionTextView.text = ""
        likeButton.isEnabled = false
        likeButton.isHidden = true
        copyrightLabel.text = ""
        shareButton.isEnabled = false
        shareButton.isHidden = true
    }
    
    /// Updates the UI with an APOD.
    func updateUI(apod: Apod)
    {
        Task {
            do {
                imageView.image = try await ApodController.fetchApodImage(imageUrl: apod.url)
                imageView.isHidden = false
                titleLabel.text = apod.title
                descriptionTextView.text = apod.description
                likeButton.isEnabled = true
                likeButton.isHidden = false
                likeButton.isLiked = likedApods.contains(where: {$0.apod == apod})
                if let copyright = apod.copyright {
                    copyrightLabel.text = "©\(copyright)"
                }
                shareButton.isEnabled = true
                shareButton.isHidden = false
            }catch {
                updateUI(error: error)
            }
        }
    }
    
    /// Updates the UI with an error.
    /// Used when there's an error.
    func updateUI(error: Error)
    {
        imageView.isHidden = true
        titleLabel.text = "Could not fetch Apod...🫤"
        descriptionTextView.text = "# Check the wifi connection.\n# Try another date.\nIf still not working try again after an hour.\nIf not, try tommorow."
        likeButton.isEnabled = false
        likeButton.isHidden = true
        copyrightLabel.text = ""
        shareButton.isEnabled = false
        shareButton.isHidden = true
    }
    
    // MARK: - Action Functions
    
    @IBAction func dateChanged(_ sender: UIDatePicker)
    {
        Task {
            do {
                fetchingApodViewUpdate()
                let date = datePicker.date.description.prefix(10)
                let query = ["api_key":"DEMO_KEY", "date":"\(date)"]
                apod = try await ApodController.fetchApodInfo(query: query)
                updateUI(apod: apod!)
            } catch {
                updateUI(error: error)
            }
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: LikeButton)
    {
        if sender.isLiked {
            print("Removed from the list.")
            
            if let apod = apod, let apodPresentAt = likedApods.firstIndex(where: {$0.apod == apod}) {
                likedApods.remove(at: apodPresentAt)
                
                ApodController.saveLikedApodsToFile(apods: likedApods)
            }
            print(likedApods.count)
        } else {
            print("Added to the list.")
            
            if let apod = apod {
                likedApods.append(LikedApod(date: datePicker.date, apod: apod))
            }
            
            ApodController.saveLikedApodsToFile(apods: likedApods)
            print(likedApods.count)
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton)
    {
        guard let apod = apod else { return }
        
        let mediaUrl = apod.url
        let description = apod.description
        
        var activityItems: [Any]
        if let image = imageView.image {
            activityItems = [image, description]
        } else {
            activityItems = [mediaUrl, description]
        }
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        present(activityVC, animated: true)
    }
}
