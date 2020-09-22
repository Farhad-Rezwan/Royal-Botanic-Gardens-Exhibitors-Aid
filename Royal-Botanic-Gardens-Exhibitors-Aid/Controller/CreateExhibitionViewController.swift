//
//  CreateExhibitionViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 6/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit
import CoreLocation

/// Create exhibition veiw controller, new exhibition is creatated with proper validation
class CreateExhibitionViewController: UIViewController {
    
    

    weak var databaseController: DatabaseProtocol?
    
    var iconSelected: Icon?
    var locationCoordinate: CLLocation?
    var plantsSelected = [Plant]()
    
    /// new exhibition details
    var temporaryExhibition: Exhibition?
    var defaultExhibitionName: String = ""
    

    @IBOutlet weak var exhibitionNameTextField: UITextField!
    
    @IBOutlet weak var exhibitionDescriptionTextField: UITextField!
    
    /// Location related
    @IBOutlet weak var locationAddedImageView: UIImageView!
    
    @IBOutlet weak var locationAddedErrorLabel: UILabel!
    
    
    /// icon related
    @IBOutlet weak var iconAddedBackground: UIView!
    @IBOutlet weak var iconAddedImageView: UIImageView!
    
    
    @IBOutlet weak var exhibitionPlantsCollectionView: UICollectionView!
    
    // making corner radious 20
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var addIconButton: UIButton!
    @IBOutlet weak var addPlantsButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!


    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        exhibitionPlantsCollectionView.dataSource = self
        exhibitionPlantsCollectionView.delegate = self

        

        // Do any additional setup after loading the view.
        makeCornerRadiousToRound()
    }
    
    func makeCornerRadiousToRound() {
        exhibitionNameTextField.layer.cornerRadius = 20
        exhibitionDescriptionTextField.layer.cornerRadius = 20
        addLocationButton.layer.cornerRadius = 20
        addIconButton.layer.cornerRadius = 20
        addPlantsButton.layer.cornerRadius = 20
        submitButton.layer.cornerRadius = 20
        exhibitionPlantsCollectionView.layer.cornerRadius = 20
        addLocationButton.layer.borderWidth = 1.0
        addIconButton.layer.borderWidth = 1.0
        addPlantsButton.layer.borderWidth = 1.0
        submitButton.layer.borderWidth = 1.0
        exhibitionPlantsCollectionView.layer.borderWidth = 1.0
        exhibitionNameTextField.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        exhibitionDescriptionTextField.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        addLocationButton.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        addIconButton.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        addPlantsButton.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        submitButton.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        exhibitionPlantsCollectionView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        locationAddedImageView.image = UIImage(named: "waiting")
        locationAddedImageView.backgroundColor = .white
        locationAddedImageView.layer.borderWidth = 1.0
        locationAddedImageView.layer.cornerRadius = iconAddedBackground.bounds.height / 2
        locationAddedImageView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        
        
        
        iconAddedImageView.image = UIImage(named: "waiting")
        iconAddedBackground.backgroundColor = .white
        iconAddedBackground.layer.borderWidth = 1.0
        iconAddedBackground.layer.cornerRadius = iconAddedBackground.bounds.height / 2
        iconAddedBackground.layer.borderColor = UIColor.systemGroupedBackground.cgColor
    }
    

    @IBAction func createExhibitionButton(_ sender: Any) {
        
//         should come up with plants atleast 3
        if exhibitionNameTextField.text != "" && exhibitionDescriptionTextField.text != "" && locationCoordinate != nil && iconSelected != nil && plantsSelected.count >= 3 {
            
            let name = exhibitionNameTextField.text!
            let description = exhibitionDescriptionTextField.text!
            let latitude: Double = (locationCoordinate?.coordinate.latitude)!
            let longitude: Double = (locationCoordinate?.coordinate.longitude)!
            let selectedIcon: String = iconSelected!.imageIconName


            temporaryExhibition = databaseController?.addExhibition(name: name, desc: description, exhibitionLat: latitude, exhibitionLon: longitude, icon: selectedIcon).0
            for singlePlant in plantsSelected {
                let _ = databaseController?.addPlantToExhibit(plant: singlePlant, exhibition: temporaryExhibition!)
            }
            

            navigationController?.popViewController(animated: true)
            return
        }
        var errorMessage = "Please ensure all fields are filled: \n"

        if exhibitionNameTextField.text == "" {
            errorMessage += "-must provide name\n"
        }

        if exhibitionDescriptionTextField.text == "" {
            errorMessage += "-must provide description\n"
        }

        if locationCoordinate == nil {
            errorMessage += "-must provide location\n"
        }
        
        if iconSelected == nil {
            errorMessage += "-must select an Icon\n"
        }
        
        if plantsSelected.count < 3 {
            errorMessage += "-plese select atleast 3 plants\n"
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
    
    @IBAction func addLocationButton(_ sender: Any) {
        // new location selected
        // location added image view: locationAddedImageView good image
    }
    
    
    @IBAction func addIconButton(_ sender: Any) {
        // scroll view type something
    }
    
    
    @IBAction func addPlantsButton(_ sender: Any) {
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocationSegue" {
            let destination = segue.destination as! SelectCustomLocation
            destination.locationDelegate = self
        } else if segue.identifier == "addIconSegue" {
            let destination = segue.destination as! SelectExhibitionIconViewController
            destination.delegate = self
        } else if segue.identifier == "addPlantsSegue" {
            let destination = segue.destination as! ExistingPlantsViewController
            destination.delegate = self
        }
        
    }

}


/// implementing delegate class and methods for SelectLocationDelegate
extension CreateExhibitionViewController: SelectLocationDelegate {
    func addLocation(coordinate: CLLocation) {
        locationCoordinate = coordinate
        
        // locationAddedImageView with good image when the location is added properly
        locationAddedImageView.image = UIImage(named: "locationAddedProperly")
        
    }
    
    
}

/// implementing delegate class and methods for SelectIconDelegate
extension CreateExhibitionViewController: SelectIconDelegate {
    func addIcon(icon: Icon) {
        self.iconSelected = icon
        iconAddedBackground.backgroundColor = iconSelected!.iconTintColor
        iconAddedImageView.image = UIImage(named: iconSelected!.imageIconName)
    }
    
    
}

/// implementing delegate class and methods for SelectedPlantsDelegate
extension CreateExhibitionViewController: SelectedPlantsDelegate {
    func addPlants(plants: [Plant]) {
        plantsSelected.removeAll()
        plantsSelected.append(contentsOf: plants)
        exhibitionPlantsCollectionView.reloadData()
        
    }
}

/// collection view controller delegate methods
extension CreateExhibitionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // should return current exhibition plant size
        return plantsSelected.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exhibitionPlantsCollectionViewCell", for: indexPath) as! ExhibitionPlantsCollectionViewCell
        
        cell.setupPlant(plant: plantsSelected[indexPath.row])
        cell.backgroundColor = UIColor.systemGray2
        
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = cell.bounds.height / 4
        cell.layer.borderColor = UIColor.systemGroupedBackground.cgColor

        return cell
    }
    
    
}
