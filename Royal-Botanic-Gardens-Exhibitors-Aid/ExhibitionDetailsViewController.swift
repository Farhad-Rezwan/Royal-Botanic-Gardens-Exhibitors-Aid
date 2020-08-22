//
//  ExhibitionDetailsViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/8/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

class ExhibitionDetailsViewController: UIViewController {
    @IBOutlet weak var exhibitNameLabel: UILabel!
    @IBOutlet weak var exhibitDescriptionLabel: UILabel!
    @IBOutlet weak var exhibitLocationLabel: UILabel!
    
    @IBOutlet weak var plantsTableView: UITableView!
    
    var currentPlant: [Plant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantsTableView.delegate = self
        plantsTableView.dataSource = self

        currentPlant = createExhibition().plants!
    }
    
    func createExhibition() -> Exhibition {
        var tempExhibition: Exhibition
        
        let plant1 = Plant(name: "Plant A", scientificName: "PA", yearDiscovered: 1990, family: "AFamily", imageURL: "www.A.com")
        let plant2 = Plant(name: "Plant B", scientificName: "PB", yearDiscovered: 1991, family: "BFamily", imageURL: "www.B.com")
        let plant3 = Plant(name: "Plant C", scientificName: "PC", yearDiscovered: 1992, family: "CFamily", imageURL: "www.C.com")
        let plant4 = Plant(name: "Plant D", scientificName: "PD", yearDiscovered: 1994, family: "DFamily", imageURL: "www.D.com")
        
        let exhibition1 = Exhibition(name: "I dont care exhibition", description: "I realy dont care", location: "Lucey if i care", plants: [plant1, plant2, plant3, plant4])
        
        tempExhibition = exhibition1
        
        
        return tempExhibition
    }
    
    

}

extension ExhibitionDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPlant.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plant = currentPlant[indexPath.row] // returns empty cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "showPlantDetailsCell") as! PlantTableViewCell
        cell.setupPlant(plant: plant)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        currentPlant.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic) // here indexPath represents the cell.
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(identifier: "showPlanet") as! PlantDetailsViewController
        viewController.plant = currentPlant[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
