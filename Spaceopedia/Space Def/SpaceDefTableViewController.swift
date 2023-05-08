//
//  SpaceDefTableViewController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 08/05/23.
//

import UIKit

class SpaceDefTableViewController: UITableViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var lookUpButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
}
