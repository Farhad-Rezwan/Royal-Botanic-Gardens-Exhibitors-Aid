//
//  EditPlantViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 5/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

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
        
        showPlantNameLable.text = plant?.name
        showScientificNameLabel.text = plant?.scientificName
        showYearDiscoveredLabel.text = "\(plant?.yearDiscovered ?? 0)"
        showFamilyNameLabel.text = plant?.family
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController

    }
        
    @IBAction func editSubmitButtonAction(_ sender: Any) {
        let familyName = editFamilyNameTextField.text
        let scientificName = editScientificNameTextField.text
        
//        newPlant.name = name

        databaseController?.editPlant(oldPlant: plant!, family: familyName!, scientificName: scientificName!)
        editDelegate?.sendPlantToEdit(plant: plant!)
        navigationController?.popViewController(animated: true)
        return
    }
}
