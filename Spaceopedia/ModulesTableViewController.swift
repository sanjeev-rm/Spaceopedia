//
//  ModulesTableViewController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 30/03/23.
//

import UIKit

class ModulesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.title = "SPACEOPEDIA"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return Modules.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moduleCell", for: indexPath) as! ModuleTableViewCell

        cell.titleLabel.text = Modules.allCases[indexPath.section].title
        cell.descriptionLabel.text = Modules.allCases[indexPath.section].description

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let module = Modules.allCases[indexPath.section]
        performSegue(withIdentifier: module.segueIdentifier, sender: self)
    }
}
