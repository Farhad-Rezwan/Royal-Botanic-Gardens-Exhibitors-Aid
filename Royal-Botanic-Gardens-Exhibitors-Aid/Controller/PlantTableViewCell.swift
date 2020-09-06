//
//  PlantTableViewCell.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/8/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

class PlantTableViewCell: UITableViewCell {
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var plantScientificNameLabel: UILabel!
    @IBOutlet weak var plantYearDiscoveredLabel: UILabel!
    @IBOutlet weak var plantFamilyLabel: UILabel!
    
    @IBOutlet weak var plantImageUrlLabel: UILabel!
    
    
    func setupPlant(plant: Plant) {
        plantNameLabel.text = plant.name
        plantScientificNameLabel.text = plant.scientificName
        plantYearDiscoveredLabel.text = "Year: \(plant.yearDiscovered)"
        plantFamilyLabel.text = plant.family
        plantImageUrlLabel.text = plant.family
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
