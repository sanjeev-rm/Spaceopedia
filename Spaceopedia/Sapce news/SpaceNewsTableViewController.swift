//
//  SpaceNewsTableViewController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 06/06/23.
//

import UIKit
import SafariServices

class SpaceNewsTableViewController: UITableViewController {
    
    /// The articles to present.
    var articles: [Article]?
    
    /// The enum that represents SpaceNewsVC states.
    private enum SpaceNewsVCState {
        case fetching
        case fetched
        case error
    }
    private var vcState = SpaceNewsVCState.fetching {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetching the Articles.
        Task {
            updateUIForFetchingState()
            do {
                articles = try await SpaceNewsController.fetchArticles().results
                updateUIForFetchedState()
            } catch {
                updateUIForErrorState()
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - helping functions
    
    /// Updates the UI foe when the VC is fetching articles.
    func updateUIForFetchingState() {
        vcState = .fetching
    }
    
    /// Updates the UI for when the VC has fetched the articles.
    func updateUIForFetchedState() {
        vcState = .fetched
    }
    
    /// Updates the UI for when the VC is in error state.
    func updateUIForErrorState() {
        vcState = .error
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        switch vcState {
        case .fetched:
            guard let articles = articles else {
                updateUIForErrorState()
                return 1
            }
            // If articles are there then no of articles is returned.
            return articles.count
        case .fetching, .error:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch vcState {
        case .fetching:
            let cell = tableView.dequeueReusableCell(withIdentifier: "spaceNewsFetchingCell", for: indexPath)
            return cell
        case .fetched:
            let cell = tableView.dequeueReusableCell(withIdentifier: "spaceNewsArticleCell", for: indexPath) as! SpaceNewsArticleTableViewCell
            
            // Unwrapping article.
            // If article not there that means something is wrong so updatesUI for error.
            guard let article = articles?[indexPath.section] else {
                updateUIForErrorState()
                return cell
            }
            
            // Updating cell with the basic info tht we already have.
            cell.update(title: article.title, copyright: article.newsSite)
            
            // Unwrapping url of the image that is string format.
            // Cheking whether the article contains an image url.
            //If not just returns the cell without an image.
            guard let imageUrlString = article.imageUrl else { return cell }
            
            Task {
                do {
                    let image = try await SpaceNewsController.fetchArticleImage(imageUrlString: imageUrlString)
                    cell.updateWith(image: image)
                } catch {
                }
            }
            
            return cell
        case .error:
            let cell = tableView.dequeueReusableCell(withIdentifier: "spaceNewsErrorCell", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articles = articles else { return }
        let urlString = articles[indexPath.section].url
        
        if let url = URL(string: urlString) {
            let safariVC = SFSafariViewController(url: url)
            // This presents the VC in modal presentation Like pop over. Looks nice.
            safariVC.modalPresentationStyle = UIModalPresentationStyle.popover
            present(safariVC, animated: true)
        } else {
            let alertVC = UIAlertController(title: "Article Unavailable", message: "", preferredStyle: .actionSheet)
            let alertAction = UIAlertAction(title: "Okay", style: .default)
            alertVC.addAction(alertAction)
            present(alertVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
