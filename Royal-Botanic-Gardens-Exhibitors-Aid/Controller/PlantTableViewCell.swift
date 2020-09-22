//
//  PlantTableViewCell.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/8/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

/// class for each plant cell
class PlantTableViewCell: UITableViewCell {
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var plantScientificNameLabel: UILabel!
    @IBOutlet weak var plantYearDiscoveredLabel: UILabel!
    @IBOutlet weak var plantFamilyLabel: UILabel!
    
    @IBOutlet weak var plantImage: CustomImageView!
    
    
    /// helps to properly set plant
    func setupPlant(plant: Plant) {
        plantNameLabel.text = plant.name
        plantScientificNameLabel.text = plant.scientificName
        plantYearDiscoveredLabel.text = "Year: \(plant.yearDiscovered)"
        plantFamilyLabel.text = plant.family
        
        guard let plantImageStr = plant.imageOfPlant else {
            plantImage.image = UIImage(named: "imageLoad")
            return
        }
        
        if let url = URL(string: convertHttpToHttps(url: plantImageStr)) {
            plantImage.loadImage(from: url)
            
        }
    }
    
    /// converts url to follow to HTTPS
    /// - Parameter url: Could be any URL starting with HTTP or HTTPS
    /// - Returns: returns URL with HTTPS
    func convertHttpToHttps(url: String) -> String {
        
        // https://stackoverflow.com/a/50164951
        let http = url
        var comps = URLComponents(string: http)!
        comps.scheme = "https"
        let https = comps.string!
        
        return https
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    /// helps to keep table view controller properly selected
    override var isSelected: Bool{
        willSet{
            super.isSelected = newValue
            if newValue
            {
                self.layer.borderWidth = 1.0
                self.layer.cornerRadius = self.bounds.height / 2
                self.layer.borderColor = UIColor.gray.cgColor
            }
            else
            {
                self.layer.borderWidth = 0.0
                self.layer.cornerRadius = 0.0
            }
        }
    }

}
