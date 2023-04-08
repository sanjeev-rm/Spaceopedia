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
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var copyrightLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    let apodController = ApodController()
    
    var apod: Apod?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.maximumDate = Date()
        
        fetchingApodViewUpdate()
        
        Task {
            do {
                let date = datePicker.date.description.prefix(10)
                let query = ["api_key":"DEMO_KEY", "date":"\(date)"]
                let apod = try await apodController.fetchApodInfo(query: query)
                
                updateUI(apod: apod)
            }catch {
                updateUI(error: error)
            }
        }
    }
    
    //MARK: - Functions
    
    /// Initial updates to the UI.
    func fetchingApodViewUpdate()
    {
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
                imageView.image = try await apodController.fetchApodImage(imageUrl: apod.url)
                imageView.isHidden = false
                titleLabel.text = apod.title
                descriptionTextView.text = apod.description
                likeButton.isEnabled = true
                likeButton.isHidden = false
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
                let apod = try await apodController.fetchApodInfo(query: query)
                updateUI(apod: apod)
            } catch {
                updateUI(error: error)
            }
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton)
    {
        let alertVC = UIAlertController(title: "Liked!", message: "Apod saved in the liked tabs.", preferredStyle: .actionSheet)
        let okayAction = UIAlertAction(title: "Okay", style:
                .default)
        alertVC.addAction(okayAction)
        present(alertVC, animated: true)
        
        if likeButton.image(for: .normal) == UIImage(systemName: "suit.heart") {
        } else {
            likeButton.imageView?.image = UIImage(systemName: "suit.heart")
        }
    }
}
