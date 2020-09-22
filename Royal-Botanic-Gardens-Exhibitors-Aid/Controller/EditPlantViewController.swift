//
//  EditPlantViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 5/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

/// Class for editing plants
class EditPlantViewController: UIViewController {
    
    var plant:Plant?
    weak var editDelegate: EditPlantDelegate?

    @IBOutlet weak var showPlantNameLable: UILabel!
    @IBOutlet weak var showScientificNameLabel: UILabel!
    @IBOutlet weak var showYearDiscoveredLabel: UILabel!
    @IBOutlet weak var showFamilyNameLabel: UILabel!
    @IBOutlet weak var editPlantNameTextField: UITextField!
    @IBOutlet weak var editScientificNameTextField: UITextField!
    @IBOutlet weak var editYearDiscoveredTextField: UITextField!
    @IBOutlet weak var editFamilyNameTextField: UITextField!
    
    
    weak var databaseController: DatabaseProtocol?
    
    
    
    @IBOutlet weak var plantNameErrorLabel: UILabel!
    @IBOutlet weak var scientificNameErrorLebel: UILabel!
    @IBOutlet weak var yearDiscoveredErrorLabel: UILabel!
    @IBOutlet weak var familyNameErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPlantNameLable.text = "Plant name: \(plant?.name ?? "no name")"
        showScientificNameLabel.text = "Scientific Name: \(plant?.scientificName ?? "no scientific name")"
        showYearDiscoveredLabel.text = "\(plant?.yearDiscovered ?? 0)"
        showFamilyNameLabel.text = "Family: \(plant?.family ?? "no family")"
        
        editPlantNameTextField.text = plant?.name ?? "no name"
        editScientificNameTextField.text = plant?.scientificName ?? "no scientific name"
        editYearDiscoveredTextField.text = "\(plant?.yearDiscovered ?? 0)"
        editFamilyNameTextField.text = plant?.family ?? "no family"
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController

    }
        
    @IBAction func editSubmitButtonAction(_ sender: Any) {
        var errorMessage = "Please ensure all fields are filled: \n"
        
        guard let yearDiscovered: Int = Int(editYearDiscoveredTextField.text ?? "0") else {
            if editYearDiscoveredTextField.text == "" {
                errorMessage += "-must provide year\n"
            }
            errorMessage += "-must provide proper year\n"
            displayMessage(title: "Not all fields filled", message: errorMessage)
            return
        }
        
        
        if editPlantNameTextField.text != "" && editFamilyNameTextField.text != "" && editScientificNameTextField.text != "" && yearDiscovered > 0 && yearDiscovered < 2020 {
            let name = editPlantNameTextField.text
            let familyName = editFamilyNameTextField.text
            let scientificName = editScientificNameTextField.text
            
            
            
            
            
            databaseController?.editPlant(oldPlant: plant!, name: name!, family: familyName!, scientificName: scientificName!, yearDiscovered: Int64(yearDiscovered))
            let _ = editDelegate?.sendPlantToEdit(plant: plant!)
            navigationController?.popViewController(animated: true)
            
            return
        }
        

        if editPlantNameTextField.text == "" {
            errorMessage += "-must provide name\n"
        }

        if editFamilyNameTextField.text == "" {
            errorMessage += "-must provide family\n"
        }

        if editScientificNameTextField.text == "" {
            errorMessage += "-must provide scientific name\n"
        }
        
        if yearDiscovered <= 0 || yearDiscovered > 2020{
            errorMessage += "-must provide proper year\n"
        }
        
        displayMessage(title: "Not all fields filled", message: errorMessage)
        
    }
    
    /// Displays Alert for invalid infomation
    /// - Parameters:
    ///   - title: the title of the alert
    ///   - message: message of the allert
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
