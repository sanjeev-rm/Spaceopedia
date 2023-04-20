//
//  LikedApodTableViewController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 14/04/23.
//

import UIKit

class LikedApodTableViewController: UITableViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var likeButton: LikeButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var copyrightLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    var apod: Apod?
    
    var apodImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fetchingApodViewUpdate()
//
//        guard let apod = apod else { return }
//
//        if let apodImage = apodImage {
//            updateUI(apod: apod, apodImage: apodImage)
//        } else {
//            do {
//                try updateUI(apod: apod)
//            } catch {
//                updateUI(error: error)
//            }
//        }
    }
    
    //MARK: - Functions
    
    /// Initial updates to the UI for when the app is fetching APOD from the NASA API.
    func fetchingApodViewUpdate()
    {
        // Gets the updated(latest) liked APODS list everytime fetching a new APOD.
//        likedApods = ApodController.loadLikedApodsFromFile()
        
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
    /// Throws when there's errors in fetching the image.
    func updateUI(apod: Apod) throws
    {
        Task {
            imageView.image = try await ApodController.fetchApodImage(imageUrl: apod.url)
            imageView.isHidden = false
            titleLabel.text = apod.title
            descriptionTextView.text = apod.description
            likeButton.isEnabled = true
            likeButton.isHidden = false
            likeButton.isLiked = ApodController.likedApods!.contains(where: {$1 == apod})
            if let copyright = apod.copyright {
                copyrightLabel.text = "©\(copyright)"
            }
            shareButton.isEnabled = true
            shareButton.isHidden = false
        }
    }
    
    /// Updates the UI with an APOD and the image provided as the apod image.
    func updateUI(apod: Apod, apodImage image: UIImage)
    {
        imageView.image = image
        imageView.isHidden = false
        titleLabel.text = apod.title
        descriptionTextView.text = apod.description
        likeButton.isEnabled = true
        likeButton.isHidden = false
        likeButton.isLiked = ApodController.likedApods!.contains(where: {$1 == apod})
        if let copyright = apod.copyright {
            copyrightLabel.text = "©\(copyright)"
        }
        shareButton.isEnabled = true
        shareButton.isHidden = false
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

    // MARK: - Table view data source
    
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
     */
    
    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
     */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
