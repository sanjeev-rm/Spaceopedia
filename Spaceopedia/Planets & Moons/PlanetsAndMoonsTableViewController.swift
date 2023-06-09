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
    @IBOutlet weak var lookUpPlanetLabel: UILabel!
    
    @IBOutlet weak var errorTextView: UITextView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var planetMoon: PlanetMoon?
    var planetMoonUrlString: String?
    
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
    
    /// Variable to keep track of whether the LookUp "planet" section is visible or not.
    var lookUpPlanetVisible = false {
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
    
    /// Updates the UI with the given PlanetMoon instance.
    func updateUIWithPlanetMoon(planetMoon: PlanetMoon) {
        resetCertainValues()
        nameLabel.text = planetMoon.name
        englishNameLabel.text = planetMoon.englishName
        typeLabel.text = planetMoon.bodyType
        massLabel.text = planetMoon.mass.getMassString()
        volumeLabel.text = planetMoon.vol.getVolumeString()
        densityLabel.text = planetMoon.density.description
        gravityLabel.text = planetMoon.gravity.description
        avgTempLabel.text = planetMoon.avgTemp.description + " K"
        meanRadiusLabel.text = planetMoon.meanRadius.description
        discoveredByLabel.text = planetMoon.discoveredBy
        discoveryDateLabel.text = planetMoon.discoveryDate
        if planetMoon.bodyType.lowercased() == "moon", let revolvesAround = planetMoon.aroundPlanet?.name {
            revolvesAroundLabel.text = "Revolves around \(revolvesAround)"
            lookUpPlanetLabel.text = "Look Up \(revolvesAround)"
        }
        
        moreLabel.text = moreDiscloseButton.isDisclosed ? MoreLabelText.less.rawValue : MoreLabelText.more.rawValue
    }
    
    /// This function resets certain values to keep the UI consistent everytime the view updates itself with a new PlanetMoon.
    func resetCertainValues() {
        moreDiscloseButton.isDisclosed = false
        lookUpPlanetVisible = false
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
        
        if let planetMoonUrlString = planetMoonUrlString{
            Task {
                do {
                    updateUIForFetchingState()
                    activityIndicator.startAnimating()
                    let planetMoonResponse = try await PlanetMoonController.fetch(urlString: planetMoonUrlString)
                    planetMoon = planetMoonResponse // Setting the views planetMoon property.
                    activityIndicator.stopAnimating()
                    updateUIWithPlanetMoon(planetMoon: planetMoonResponse)
                    switch planetMoonResponse.bodyType.lowercased() {
                    case PlanetMoonBodyType.planet.rawValue : updateUIForPlanetState()
                    case PlanetMoonBodyType.moon.rawValue : updateUIForMoonState()
                    case PlanetMoonBodyType.star.rawValue : updateUIForStarState()
                    case PlanetMoonBodyType.dwarfPlanet.rawValue : updateUIForPlanetState()
                    case PlanetMoonBodyType.asteroid.rawValue : updateUIForStarState()
                    default: updateUIForErrorState(error: "Woah new type of object!")
                    }
                } catch {
                    updateUIForErrorState(error: "Sorry couldn't find what you were looking for.")
                }
            }
        } else {
            updateUIForNothingState()
        }
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        guard let word = textField.text, !word.isEmpty else {
            planetMoonUrlString = nil
            return
        }
        // Setting the planetMoon to search
        planetMoonUrlString = PlanetMoonAPI.getRequestUrlWith(word: word)
    }
    
    // MARK: - Table view data source
    
    // Sections -->
    // 0 - textField
    // 1 - look up button
    // 2 - activity indicator
    // 3 - error text view
    // 4 - basic info section
    // 5 - more info disclose button section
    // 6 - more info section
    // 7 - moons section
    // 8 - revolves around "planet" section
    // 9 - images section
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // For more info disclosure section.
        if indexPath == IndexPath(row: 0, section: 5) {
            moreDiscloseButton.toggleIsDisclosed()
            moreLabel.text = moreDiscloseButton.isDisclosed ? MoreLabelText.less.rawValue : MoreLabelText.more.rawValue
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        // When the Revolves around "planet" row is tapped then the Look Up "planet" row shows up.
        // And everytime this Revolves around "planet" row is touched the Look Up "planet" row toggles.
        if indexPath == IndexPath(row: 0, section: 8) {
            lookUpPlanetVisible.toggle()
        }
        
        if indexPath == IndexPath(row: 1, section: 8) {
            guard let planetMoon = planetMoon, let revolvesAround = planetMoon.aroundPlanet?.name else { return }
            // Sets the textField text to the planet.
            textField.text = revolvesAround
            // Calling this method to update the planetMoonUrlString.
            textFieldEditingChanged(textField)
            // Calls the function that is called when the LookUp button is tapped.
            lookUpButtonTapped(lookUpButton)
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
            case 8: return (indexPath.row == 1 && !lookUpPlanetVisible) ? 0 : tableView.estimatedRowHeight
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
            case 2, 3, 6, 8: return 0
            default: return tableView.estimatedSectionHeaderHeight
            }
        } else if moonState {
            switch section {
            case 2, 3, 6, 7: return 0
            default: return tableView.estimatedSectionHeaderHeight
            }
        } else if starState {
            switch section {
            case 2, 3, 6, 7, 8: return 0
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
            case 2, 3, 5, 8: return 0
            default: return tableView.estimatedSectionFooterHeight
            }
        } else if moonState {
            switch section {
            case 2, 3, 5, 7: return 0
            default: return tableView.estimatedSectionFooterHeight
            }
        } else if starState {
            switch section {
            case 2, 3, 5, 7, 8: return 0
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
    
    // MARK: - Navigation segue functions.
    
    @IBSegueAction func moonsViewSegue(_ coder: NSCoder) -> UITableViewController? {
        let moonsVC = MoonsTableViewController(coder: coder)
        moonsVC?.moons = planetMoon?.moons
        moonsVC?.navigationItem.title = "\(planetMoon?.englishName ?? "")'s Moons"
        return moonsVC
    }
    
    @IBSegueAction func imagesViewSegue(_ coder: NSCoder) -> UITableViewController? {
        let imagesVC = ImagesTableViewController(coder: coder)
        imagesVC?.planetMoon = planetMoon
        imagesVC?.navigationItem.title = "\(planetMoon?.englishName ?? "")"
        return imagesVC
    }
    // MARK: - Unwind Function
    
    @IBAction func unwindToPlanetsAndMoonsView(unwindSegue: UIStoryboardSegue) {
        let moonsVC = unwindSegue.source as! MoonsTableViewController
        let indexOfSelectedRow = moonsVC.tableView.indexPathForSelectedRow!.row
        textField.text = moonsVC.moons![indexOfSelectedRow].infoUrlString.split(separator: "/").last?.description
        textFieldEditingChanged(textField)
        lookUpButtonTapped(lookUpButton)
    }
}
