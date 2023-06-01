//
//  ImagesTableViewController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 01/06/23.
//

import UIKit

class ImagesTableViewController: UITableViewController {
    
    var planetMoon: PlanetMoon?
    var picsAPIResponse: PicsAPIResponse?
    
    private enum ImagesVCState {
        case fetching
        case fetched
        case error
    }
    private var vcState: ImagesVCState = ImagesVCState.fetching {
        didSet {
            tableView.reloadData()
        }
    }
    
    func updateUIForImagesState() {
        vcState = .fetched
    }
    
    func updateUIForFetchingState() {
        vcState = .fetching
    }
    
    func updateUIForErrorState() {
        vcState = .error
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let planetMoon = planetMoon else { return }
        
        Task {
            do {
                updateUIForFetchingState()
                picsAPIResponse = try await PicsController.fetchPicsOf(word: planetMoon.bodyType + " " + planetMoon.englishName)
                updateUIForImagesState()
            } catch {
                updateUIForErrorState()
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        switch vcState {
        case .fetched:
            guard let pics = picsAPIResponse?.pics else { return 0 }
            return pics.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch vcState {
        case .fetching:
            let cell = tableView.dequeueReusableCell(withIdentifier: "planetMoonImagesFetchingCell", for: indexPath)
            return cell
        case .error:
            let cell = tableView.dequeueReusableCell(withIdentifier: "planetMoonImagesErrorCell", for: indexPath)
            return cell
        case .fetched:
            let cell = tableView.dequeueReusableCell(withIdentifier: "planetMoonImageCell", for: indexPath) as! ImagesTableViewCell
            
            let pic = picsAPIResponse?.pics[indexPath.section]
            
            cell.descriptionLabel.text = pic?.alternateDescription
            cell.copyrightLabel.text = "© \(pic?.photographer.firstName ?? "") \(pic?.photographer.lastName ?? "")"
            
            if let imageUrlString = pic?.imageUrls.regular,
               let imageUrl = URL(string: imageUrlString) {
                Task {
                    do {
                        cell.cellImageView.image = try await PicsController.fetchImageWithUrl(url: imageUrl)
                    } catch {
                        cell.cellImageView.image = UIImage(systemName: "sparkles.square.filled.on.square")
                    }
                }
            } else {
                cell.cellImageView.image = UIImage(systemName: "sparkles.square.filled.on.square")
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
