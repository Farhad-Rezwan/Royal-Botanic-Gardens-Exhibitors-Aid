//
//  PlantDetailsViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/8/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

class PlantDetailsViewController: UIViewController {
    
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var plantScientificNameLabel: UILabel!
    @IBOutlet weak var plantYearDiscoveredLabel: UILabel!
    @IBOutlet weak var plantFamilyLabel: UILabel!
    @IBOutlet weak var plantImageURLLabel: UILabel!
    
    var plant: Plant?
    
    var name: String?
    var scientificName: String?
    var yearDiscovered: Int?
    var family: String?
    var imageURL: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name = plant!.name!
        scientificName = plant?.scientificName
        yearDiscovered = plant?.yearDiscovered
        family = plant?.family
        imageURL = plant?.imageURL
        
        plantNameLabel.text = name
        plantScientificNameLabel.text = scientificName
        plantFamilyLabel.text = family
        plantYearDiscoveredLabel.text = "year: \(yearDiscovered!)"
        plantImageURLLabel.text = imageURL
    }

}
