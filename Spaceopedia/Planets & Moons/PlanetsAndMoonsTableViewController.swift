//
//  PlanetsAndMoonsTableViewController.swift
//  Spaceopedia
//
//  Created by Sanjeev RM on 17/05/23.
//

import UIKit

class PlanetsAndMoonsTableViewController: UITableViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var lookUpButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var englishNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var moreDiscloseButton: DiscloseButton!
    
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var densityLabel: UILabel!
    @IBOutlet weak var gravityLabel: UILabel!
    @IBOutlet weak var avgTempLabel: UILabel!
    @IBOutlet weak var meanRadiusLabel: UILabel!
    @IBOutlet weak var discoveredByLabel: UILabel!
    @IBOutlet weak var discoveryDateLabel: UILabel!
    
    @IBOutlet weak var revolvesAroundLabel: UILabel!
    
    @IBOutlet weak var errorTextView: UITextView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var nothingState = true {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    var fetchingState = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    var planetState = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    var moonState = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    var starState = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    var errorState = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    // MARK: - Enum
    
    /// The text on the More Label of section(button).
    enum MoreLabelText: String {
        case more = "More"
        case less = "Less"
    }
    
    // MARK: - Functions
    
    func updateUIForNothingState() {
        nothingState = true
        fetchingState = false
        planetState = false
        moonState = false
        starState = false
        errorState = false
    }
    
    func updateUIForFetchingState() {
        nothingState = false
        fetchingState = true
        planetState = false
        moonState = false
        starState = false
        errorState = false
    }
    
    func updateUIForPlanetState() {
        nothingState = false
        fetchingState = false
        planetState = true
        moonState = false
        starState = false
        errorState = false
    }
    
    func updateUIForMoonState() {
        nothingState = false
        fetchingState = false
        planetState = false
        moonState = true
        starState = false
        errorState = false
    }
    
    func updateUIForStarState() {
        nothingState = false
        fetchingState = false
        planetState = false
        moonState = false
        starState = true
        errorState = false
    }
    
    func updateUIForErrorState(error: String) {
        nothingState = false
        fetchingState = false
        planetState = false
        moonState = false
        starState = false
        errorState = true
        
        errorTextView.text = error
    }
    
    func updateUIWithPlanetMoon(planetMoon: PlanetMoon) {
        nameLabel.text = planetMoon.name
        englishNameLabel.text = planetMoon.englishName
        typeLabel.text = planetMoon.bodyType
        massLabel.text = planetMoon.mass.getMassString()
        volumeLabel.text = planetMoon.vol.getVolumeString()
        densityLabel.text = planetMoon.density.description
        gravityLabel.text = planetMoon.gravity.description
        avgTempLabel.text = planetMoon.avgTemp.description + "K"
        meanRadiusLabel.text = planetMoon.meanRadius.description
        discoveredByLabel.text = planetMoon.discoveredBy
        discoveryDateLabel.text = planetMoon.discoveryDate
        if planetMoon.bodyType.lowercased() == "moon", let revolvesAround = planetMoon.aroundPlanet?.name {
            revolvesAroundLabel.text = "Revolves around \(revolvesAround)"
        }
        
        moreLabel.text = moreDiscloseButton.isDisclosed ? MoreLabelText.less.rawValue : MoreLabelText.more.rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Action functions

    @IBAction func lookUpButtonTapped(_ sender: UIButton) {
        if let word = textField.text, !word.isEmpty {
            Task {
                do {
                    updateUIForFetchingState()
                    activityIndicator.startAnimating()
                    let planetMoonResponse = try await PlanetMoonController.fetch(planetOrMoon: word)
                    activityIndicator.stopAnimating()
                    updateUIWithPlanetMoon(planetMoon: planetMoonResponse)
                    switch planetMoonResponse.bodyType.lowercased() {
                    case "planet": updateUIForPlanetState()
                    case "moon": updateUIForMoonState()
                    case "star": updateUIForStarState()
                    case "dwarf planet" : updateUIForPlanetState()
                    default: updateUIForErrorState(error: "Woah new type of object!")
                    }
                } catch {
                    updateUIForErrorState(error: "Sorry couldnt find what you were looking for.")
                }
            }
        } else {
            updateUIForNothingState()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == IndexPath(row: 0, section: 5) {
            moreDiscloseButton.toggleIsDisclosed()
            moreLabel.text = moreDiscloseButton.isDisclosed ? MoreLabelText.less.rawValue : MoreLabelText.more.rawValue
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 || indexPath.section == 1 {
            return tableView.estimatedRowHeight
        }
        
        if nothingState {
            return 0
        } else if fetchingState {
            if indexPath.section == 2 {
                return tableView.estimatedRowHeight
            } else {
                return 0
            }
        } else if planetState {
            switch indexPath.section {
            case 2, 3, 8: return 0
            case 6: return moreDiscloseButton.isDisclosed ? tableView.estimatedRowHeight : 0
            default: return tableView.estimatedRowHeight
            }
        } else if moonState {
            switch indexPath.section {
            case 2, 3, 7: return 0
            case 6: return moreDiscloseButton.isDisclosed ? tableView.estimatedRowHeight : 0
            default: return tableView.estimatedRowHeight
            }
        } else if starState {
            switch indexPath.section {
            case 2, 3, 7, 8: return 0
            case 6: return moreDiscloseButton.isDisclosed ? tableView.estimatedRowHeight : 0
            default: return tableView.estimatedRowHeight
            }
        }else if errorState {
            switch indexPath.section {
            case 3: return 120
            default: return 0
            }
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    // MARK: Setting height for each section header and footer in table view.
    // For this to work as expected set the expected value of header height and footer height in storyboard.
    // And set the header and footer heoght as 0(minimum 1) in storyboard.
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return tableView.estimatedSectionHeaderHeight
        }
        
        if nothingState {
            return 0
        } else if fetchingState {
            if section == 2 {
                return tableView.estimatedSectionHeaderHeight
            } else {
                return 0
            }
        } else if planetState {
            switch section {
            case 2, 3, 8: return 0
            default: return tableView.estimatedSectionHeaderHeight
            }
        } else if moonState {
            switch section {
            case 2, 3, 7: return 0
            default: return tableView.estimatedSectionHeaderHeight
            }
        } else if starState {
            switch section {
            case 2, 3, 7, 8: return 0
            default: return tableView.estimatedSectionHeaderHeight
            }
        } else if errorState {
            switch section {
            case 3: return tableView.estimatedSectionHeaderHeight
            default: return 0
            }
        } else {
            return tableView.estimatedSectionHeaderHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return tableView.estimatedSectionFooterHeight
        }
        
        if nothingState {
            return 0
        } else if fetchingState {
            if section == 2 {
                return tableView.estimatedSectionFooterHeight
            } else {
                return 0
            }
        } else if planetState {
            switch section {
            case 2, 3, 8: return 0
            default: return tableView.estimatedSectionFooterHeight
            }
        } else if moonState {
            switch section {
            case 2, 3, 7: return 0
            default: return tableView.estimatedSectionFooterHeight
            }
        } else if starState {
            switch section {
            case 2, 3, 7, 8: return 0
            default: return tableView.estimatedSectionFooterHeight
            }
        } else if errorState {
            switch section {
            case 3: return tableView.estimatedSectionFooterHeight
            default: return 0
            }
        } else {
            return tableView.estimatedSectionFooterHeight
        }
    }
}
