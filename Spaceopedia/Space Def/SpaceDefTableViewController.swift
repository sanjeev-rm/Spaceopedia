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
    @IBOutlet weak var definitionTextView: UITextView!
    @IBOutlet weak var extendedDiscloseButton: DiscloseButton!
    @IBOutlet weak var extendedDefinitionTextView: UITextView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // State when the app is fetching the definition.
    var fetchingDefinitionState: Bool = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    // State when the user just entered the view. OR when the text field is empty i.e. nothing has been entered yet.
    var nothingState: Bool = true {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Function updates the UI for when the app is fetching definition.
    /// It sets the boolean values fetchingDefinitionState and nothingState,
    /// Therefore it inturn updates the UI. As it kinda reloads the tableview by begining and ending updates when the value of the boolean values change.
    func updateUIForFetchingDefinition() {
        fetchingDefinitionState = true
        nothingState = false
//        definitionTextView.text = "Fetching definition..."
    }
    
    /// Function updates the UI for when the app is in the nothing state. (i.e. like before even have entered anything)
    /// It sets the boolean values fetchingDefinitionState and nothingState,
    /// Therefore it inturn updates the UI. As it kinda reloads the tableView by begining and ending updates when the value of the boolean values change.
    func updateUIForNothingState() {
        nothingState = true
        fetchingDefinitionState = false
    }
    
    /// Function updates the UI for when the app is showing definition or error.
    /// It sets the boolean values fetchingDefinitionState and nothingState,
    /// Therefore it inturn updates the UI. As it kinda reloads the tableView by begining and ending updates when the value of the boolean values change.
    func updateUIForDefinition() {
        nothingState = false
        fetchingDefinitionState = false
    }
    
    /// This function resets certain values to keep the UI consistent everytime the view updates itself with a new Definition.
    func resetCertainValues() {
        extendedDiscloseButton.isDisclosed = false
    }
    
    // MARK: - Action functions
    
    @IBAction func lookUpButtonTapped(_ sender: UIButton) {
        resetCertainValues()
        if let word = textField.text, !word.isEmpty {
            Task {
                do {
                    updateUIForFetchingDefinition()
                    activityIndicator.startAnimating()
                    let definitionResponse = try await DefinitionController.fetchDefinition(word: word)
                    let extendedDefinitonResponse = try await DefinitionController.fetchExtendedDefinition(word: word)
                    activityIndicator.stopAnimating()
                    definitionTextView.text = definitionResponse.meanings[0].definitions[0].definition
                    extendedDefinitionTextView.text = extendedDefinitonResponse.definition
                    updateUIForDefinition()
                } catch DefinitionController.DefinitionError.notFound {
                    definitionTextView.text = "Sorry, we couldn't find definitions for the word you were looking for." +
                                              "\nYou can try the search again at later time or head to the web instead."
                    extendedDefinitionTextView.text = "Sorry, couldn't get the extended definition for the word you were looking for."
                    updateUIForDefinition()
                } catch DefinitionController.DefinitionError.extendedNotFound {
                    extendedDefinitionTextView.text = "Sorry, couldn't get the extended definition for the word you were looking for."
                    updateUIForDefinition()
                }
            }
        } else {
            updateUIForNothingState()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // When the extended button(row) is selected.
        if indexPath == IndexPath(row: 0, section: 3) {
            // Toggles the isDisclosed variable in the disclose button.
            extendedDiscloseButton.toggleIsDisclosed()
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // For the first two sections the search bat text field and the lookUp button.
        if indexPath == IndexPath(row: 0, section: 0) || indexPath == IndexPath(row: 0, section: 1) {
            return tableView.estimatedRowHeight
        }
        
        // For the nothing state and the fetchingDefenitionState.
        if nothingState {
            return 0
        } else if fetchingDefinitionState {
            switch indexPath {
            case IndexPath(row: 0, section: 2):
                return tableView.estimatedRowHeight
            default:
                return 0
            }
        }
        
        // For when the app is not fetching the definition. i.e. The app has fetched the definition or threw error.
        // Also for the extended section row.
        // When we have got the definition.
        // For the remaining rows(sections).
        switch indexPath {
        case IndexPath(row: 0, section: 2):
            return 0
        case IndexPath(row: 1, section: 2):
            return 125
        case IndexPath(row: 1, section: 3):
            // If the isDisclosed variable is true then makes height 243 to show the extended section row.
            return extendedDiscloseButton.isDisclosed ? 243 : 0
        default:
            return tableView.estimatedRowHeight
        }
    }
}
