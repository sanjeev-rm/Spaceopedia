//
//  LikedTableViewController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 08/04/23.
//

import UIKit

class LikedTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
                let date = Array(ApodController.likedApods!.keys)[indexPath.section]
                let apod = Array(ApodController.likedApods!.values)[indexPath.section]
                likedCell.activityIndicator.startAnimating()
                let image = try await ApodController.fetchApodImage(imageUrl: apod.url)
                likedCell.activityIndicator.stopAnimating()
                likedCell.update(image: image, title: apod.title, date: date)
            } catch {
                print("Liked Apod cell image couldn't be fetched.")
                likedCell.update(image: UIImage(systemName: "photo")!, title: "Image couldn't fetched.", date: Date())
            }
        }
        
        return likedCell
    }

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
