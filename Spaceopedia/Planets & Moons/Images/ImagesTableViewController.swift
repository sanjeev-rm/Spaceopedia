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
    
    /// The dictionary of Pics of the API response.
    /// The key is the url of type String which is unique for each pic.
    /// The value is the pic(image) itself of type UIImage.
    var picsImages: [String : UIImage] = [:]
    
    /// An enum type representing the state the VC is in.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let planetMoon = planetMoon else { return }
        
        Task {
            do {
                updateUIForFetchingState()
                picsAPIResponse = try await PicsController.fetchPicsOf(word: planetMoon.englishName)
                updateUIForImagesState()
            } catch {
                print("\n\n\nERROR : \(error)\n\n\n")
                updateUIForErrorState()
            }
        }
    }
    
    // MARK: - update UI functions
    
    func updateUIForImagesState() {
        vcState = .fetched
    }
    
    func updateUIForFetchingState() {
        vcState = .fetching
    }
    
    func updateUIForErrorState() {
        vcState = .error
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        switch vcState {
        case .fetched:
            guard let pics = picsAPIResponse?.collection.pics else { return 0 }
            return pics.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            
            let pic = picsAPIResponse?.collection.pics[indexPath.section]
            
            cell.descriptionLabel.text = pic?.data[0].title
            cell.copyrightLabel.text = pic?.data[0].dateCreated
//            cell.copyrightLabel.text = "© \(pic?.photographer.firstName ?? "") \(pic?.photographer.lastName ?? "")"
            
            if let imageUrlString = pic?.links[0].url,
               let imageUrl = URL(string: imageUrlString) {
                Task {
                    do {
                        let image = try await PicsController.fetchImageWithUrl(url: imageUrl)
                        cell.cellImageView.image = image
                        // Adding the image to picsImage Dictionary with it's url.
                        picsImages[pic!.url] = image
                    } catch {
                        print("Unable to fetch the image. Therefore the default image will be shown. That was set in storyboard.")
                    }
                }
            }
            
            return cell
        }
    }
    
    // MARK: - Segue Action functions.
    
    @IBSegueAction func imageViewSegue(_ coder: NSCoder, sender: Any?) -> ImageViewController? {
        guard let selectedIndex = tableView.indexPathForSelectedRow?.section else {
            print("Error")
            return nil
        }
        
        let imageVC = ImageViewController(coder: coder)
        
        if !picsImages.isEmpty,
           let picsAPIResponse = picsAPIResponse {
            let pics = picsAPIResponse.collection.pics
            // Setting the VC's image to pic respective to the pic url.
            imageVC?.image = picsImages[pics[selectedIndex].url]
            
            // MARK: - for when you want to show the description along with the image too.
            /* For version 2.0
             * Uncomment this and create a description variable in ImageViewController.
             * And present this.
             */
            //imageVC?.description = pics[selectedIndex].data.first!.description
            
            
        }
        
        imageVC?.sourceView = .planetsAndMoonsImagesView
        
        return imageVC
    }
    
    // MARK: - Unwind functions
    
    @IBAction func unwindToPlanetsAndMoonsImages(unwindSegue: UIStoryboardSegue) {
    }
}
