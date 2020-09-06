//
//  PlantDetailsViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/8/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

class PlantDetailsViewController: UIViewController, EditPlantDelegate, DatabaseListener {
    var listenerType: ListenerType = .all
    
    func onExhibitionPlantsChange(change: DatabaseChange, exhibitionPlants: [Plant]) {
        
    }
    
    func onPlantListChange(change: DatabaseChange, plants: [Plant]) {
        
    }
    
    func onExhibitionChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        
    }
    
    
    

    weak var databaseController: DatabaseProtocol?
    
    
//    weak var editPlantDelegate: EditPlantDelegate?
    
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var plantScientificNameLabel: UILabel!
    @IBOutlet weak var plantYearDiscoveredLabel: UILabel!
    @IBOutlet weak var plantFamilyLabel: UILabel!
    @IBOutlet weak var plantImageURLLabel: UILabel!
    
    var plant: Plant?
    
    var name: String?
    var scientificName: String?
    var yearDiscovered: Int64?
    var family: String?
    var imageURL: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        name = plant!.name!
        scientificName = plant?.scientificName
        yearDiscovered = plant?.yearDiscovered
        family = plant?.family
        imageURL = plant?.imageOfPlant
        
        plantNameLabel.text = name
        plantScientificNameLabel.text = scientificName
        plantFamilyLabel.text = family
        plantYearDiscoveredLabel.text = "year: \(yearDiscovered!)"
        plantImageURLLabel.text = imageURL
        print(plant!)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditPlantScreen" {
//            editPlantDelegate?.sendPlantToEdit(plant: plant!)
            let destination = segue.destination as! EditPlantViewController
            destination.plant = plant
            destination.editDelegate = self
        }
    }
    
    func sendPlantToEdit(plant: Plant) -> Plant {
        self.plant = plant
        return plant
    }
    
    

}
