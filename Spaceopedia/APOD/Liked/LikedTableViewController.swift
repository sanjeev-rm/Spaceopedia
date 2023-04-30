//
//  LikedTableViewController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 08/04/23.
//

import UIKit

class LikedTableViewController: UITableViewController {
    
    /// Instance of UIRefreshController for the pull-to-refresh functionality.
    private var pullRefresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Implementing the Pull-to-Refresh functinality.
        pullRefresh.attributedTitle = NSAttributedString("")
        pullRefresh.addTarget(self, action: #selector(pulledRefreshController(_:)), for: .valueChanged)
        tableView.addSubview(pullRefresh)
    }
    
    /// @objc sction function for the pull to refresh functionality.
    @objc func pulledRefreshController(_ sender: Any)
    {
        // Reloading the data.
        tableView.reloadData()
        // Ending the refreshing.
        pullRefresh.endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if let likedApodsCount = ApodController.likedApods?.count {
            return likedApodsCount
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let likedCell = tableView.dequeueReusableCell(withIdentifier: "LikedCell", for: indexPath) as! LikedTableViewCell
        
        Task {
            do {
                let date = ApodController.likedApods![indexPath.section].date
                let apod = ApodController.likedApods![indexPath.section].apod
                likedCell.activityIndicator.startAnimating()
                var image: UIImage = UIImage()
                if apod.mediaType == "image" {
                    image = try await ApodController.fetchApodImage(imageUrl: apod.url)
                } else if apod.mediaType == "video" {
                    image = UIImage(systemName: "play.circle.fill")!.applyingSymbolConfiguration(.init(hierarchicalColor: .systemGray))!
                }
                likedCell.activityIndicator.stopAnimating()
                likedCell.update(image: image, title: apod.title, date: date)
            } catch {
                print("Liked Apod cell image couldn't be fetched.")
                likedCell.update(image: UIImage(systemName: "photo")!, title: "Image couldn't be fetched.", date: Date())
            }
        }
        
        return likedCell
    }
    
    // MARK: - Segue Action functions
    
    @IBSegueAction func likedApodViewSegue(_ coder: NSCoder) -> LikedApodTableViewController? {
        // This condition prevents the app from crashing when then user switches from the liked apods to apod page and dislikes an apod then goes back to the liked apods before reloading the liked apods page then selected the diskliked.
        guard ApodController.likedApods!.count > tableView.indexPathForSelectedRow!.section else {
            let likedApodVC = LikedApodTableViewController(coder: coder)
            likedApodVC?.likedApodError = LikedApodError(title: "Apod not in favourites.", message: "Selected Apod is not present in the favourites.")
            return likedApodVC
        }
        
        let selectedLikedApod = ApodController.likedApods![tableView.indexPathForSelectedRow!.section]
        
        let likedApodVC = LikedApodTableViewController(coder: coder)
        likedApodVC?.likedApod = selectedLikedApod
        return likedApodVC
    }
}
