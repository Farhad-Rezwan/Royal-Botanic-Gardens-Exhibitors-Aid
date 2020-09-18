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
    
    @IBOutlet weak var plantImage: CustomImageView!
    
    
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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
