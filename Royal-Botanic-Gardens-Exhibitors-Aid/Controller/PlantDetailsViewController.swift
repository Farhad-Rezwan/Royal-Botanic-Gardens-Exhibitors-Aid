//
//  PlantDetailsViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/8/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

/// class for plant details
class PlantDetailsViewController: UIViewController, EditPlantDelegate{


    

    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var plantScientificNameLabel: UILabel!
    @IBOutlet weak var plantYearDiscoveredLabel: UILabel!
    @IBOutlet weak var plantFamilyLabel: UILabel!

    @IBOutlet weak var customInagePlant: CustomImageView!
    
    var plant: Plant?
    
    var name: String?
    var scientificName: String?
    var yearDiscovered: Int64?
    var family: String?
    var imageURL: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    /// loads data so that the information is consistent, instead of using listener
    func loadData() {
        name = plant!.name!
        scientificName = plant?.scientificName
        yearDiscovered = plant?.yearDiscovered
        family = plant?.family
        imageURL = plant?.imageOfPlant
        
        plantNameLabel.text = "Name: \(name ?? "no name set")"
        plantScientificNameLabel.text = "Scientific Name: \"\(scientificName ?? "no scientific name given")\""
        plantFamilyLabel.text = "Family: \"\(family ?? "no family discovered")\""
        plantYearDiscoveredLabel.text = "Year Discovered: \(String(yearDiscovered!))"
        
        if let url = URL(string: convertHttpToHttps(url: imageURL ?? " ")) {
            customInagePlant.loadImage(from: url)
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditPlantScreen" {
            
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
