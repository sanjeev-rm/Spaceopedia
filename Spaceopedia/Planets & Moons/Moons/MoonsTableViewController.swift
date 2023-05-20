//
//  MoonsTableViewController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 19/05/23.
//

import UIKit

class MoonsTableViewController: UITableViewController {
    
    var moons: [Moon]?
    
    var lookUpMoon: Moon?

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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return moons == nil ? 0 : moons!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moonCell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = moons![indexPath.row].name
        cell.contentConfiguration = content

        return cell
    }
}
