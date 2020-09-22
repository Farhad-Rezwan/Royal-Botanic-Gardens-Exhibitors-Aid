//
//  ExhibitionPlantsCollectionViewCell.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

/// shows the exhibition plants in collection view cell once the exhibition plant is selected for new exhibition
class ExhibitionPlantsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var customImageViewPlants: CustomImageView!
    @IBOutlet weak var plantNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    
    /// setups plant
    /// - Parameter plant: a single plant
    func setupPlant(plant: Plant) {
        plantNameLabel.text = plant.name

        guard let plantImageStr = plant.imageOfPlant else {
            customImageViewPlants.image = UIImage(named: "imageLoad")
            
            return
        }
        
        if let url = URL(string: convertHttpToHttps(url: plantImageStr)) {
            customImageViewPlants.loadImage(from: url)
            
        }
        
        // docorating uI
        customImageViewPlants.layer.borderWidth = 1.0
        customImageViewPlants.layer.cornerRadius = customImageViewPlants.bounds.height / 2
        customImageViewPlants.layer.borderColor = UIColor.green.cgColor
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
}
