//
//  SpacePicTableViewController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 01/06/23.
//

import UIKit

class SpacePicTableViewController: UITableViewController {
    
    var picsAPIResponse: PicsAPIResponse?
    
    var textFieldTerm: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

//    @IBAction func lookUpButtonTapped(_ sender: UIButton) {
//        guard let text = textField.text else {
//            return
//        }
//
//        Task {
//            do {
//                picsAPIResponse = try await PicsController.fetchPicsOf(word: text)
//                tableView.beginUpdates()
//                tableView.endUpdates()
//            }
//            catch {
//                print(error)
//            }
//        }
//    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        guard let pics = picsAPIResponse?.pics else { return 2 }
        return 2 + pics.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "spacePicTextFieldCell", for: indexPath) as! SpacePicTextFieldTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "spacePicLookUpButtonCell", for: indexPath) as! SpacePicLookUpTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "spacePicCell", for: indexPath) as! SpacePicTableViewCell
            Task {
                do {
                    let spacePic = picsAPIResponse?.pics[indexPath.section - 2]
                    cell.spacePicDescriptionLabel.text = spacePic?.alternateDescription
                    cell.spacePicCopyrightLabel.text = (spacePic?.photographer.firstName ?? "") + " " + (spacePic?.photographer.lastName ?? "")
                    if let imageUrlString = spacePic?.imageUrls.regular,
                       let imageUrl = URL(string: imageUrlString) {
                        cell.spacePicImageView.image = try await PicsController.fetchImageWithUrl(url: imageUrl)
                    } else {
                        cell.spacePicImageView.image = UIImage(systemName: "sparkles.square.filled.on.square")
                    }
                } catch {
                    print(error)
                }
            }
            return cell
        }
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
