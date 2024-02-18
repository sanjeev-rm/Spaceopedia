//
//  SettingsTableViewController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 18/02/24.
//

import UIKit
import MessageUI
import SafariServices

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            print("DEBUG: mail composer finished")
        }
    }
    
    // Presents the personal websitte of the developer
    func presentPersonalWebsite() {
        guard let url = URL(string: "https://www.sanjeevragunathan.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    // Takes the user to the app store directly to this apps' review page
    func presentAppStoreReviewPageOfTheApp() {
        let appID = "6469634189"
        let url = "https://itunes.apple.com/app/id\(appID)?action=write-review"
        if let path = URL(string: url) {
                UIApplication.shared.open(path, options: [:], completionHandler: nil)
        }
    }
    
    /// Sends mail to the developer with the given subject and body
    /// - Parameter subject: the subject of the mail
    /// - Parameter body: the body of the mail
    func sendEmail(subject: String, body: String = "") {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self
            vc.setSubject(subject)
            vc.setToRecipients(["sanjeevraghu2050@gmail.com"])
            vc.setMessageBody(body, isHTML: false)
            present(vc, animated: true)
        } else {
            print("DEBUG: can't send mail")
            presentPersonalWebsite()
        }
    }
    
    /// Generates a message body to add to the mail being sent
    /// - Parameter keyword: this is the keyword used in the last line of the message body
    func getMessageBody(keyword: String) -> String{
        return
                """
                Application name: Spaceopedia
                Application version: \(Bundle.main.releaseVersionNumber ?? "")
                Application build: \(Bundle.main.buildVersionNumber ?? "")
                Please describe your \(keyword) below:
                -----------------------------------------
                \n
                """
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch [indexPath.section, indexPath.row] {
        case [0, 0]:
            print("DEBUG: settings help")
            sendEmail(subject: "Need Help [Spaceopedia]",
                      body: getMessageBody(keyword: "needs"))
        case [0, 1]:
            print("DEBUG: settings report a bug")
            sendEmail(subject: "Reporting a Bug [Spaceopedia]",
                      body: getMessageBody(keyword: "bug"))
        case [1, 0]:
            print("DEBUG: settings give a suggestion")
            sendEmail(subject: "Providing Suggestions [Spaceopedia]",
                      body: getMessageBody(keyword: "suggestion"))
        case [1, 1]:
            print("DEBUG: settings write a review")
            presentAppStoreReviewPageOfTheApp()
        case [2, 0]:
            print("DEBUG: settings meet the developer")
            presentPersonalWebsite()
        default:
            print("DEBUG: settings cell tapped")
            presentPersonalWebsite()
        }
    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
