//
//  ExhibitionDetailsViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/8/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

class ExhibitionDetailsViewController: UIViewController, DatabaseListener {
    
    var defaultExhibitionName: String = ""
    
    var listenerType: ListenerType = .all
    
    
    
    @IBOutlet weak var exhibitNameLabel: UILabel!
    @IBOutlet weak var exhibitDescriptionLabel: UILabel!
    @IBOutlet weak var exhibitLocationLabel: UILabel!
    
    @IBOutlet weak var plantsTableView: UITableView!
    
    var currentPlant: [Plant] = []
    var exhibition: Exhibition?
    
    
    weak var databaseController: DatabaseProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        plantsTableView.delegate = self
        plantsTableView.dataSource = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        databaseController?.addListener(listener: self)
        
        
        if exhibition != nil {
            exhibitNameLabel.text = "name: \(exhibition!.name ?? "Nil")"
            exhibitDescriptionLabel.text = "name: \(exhibition!.desc ?? "Nil")"
            exhibitLocationLabel.text = "name: \(String(exhibition!.exhibitionLat))" + "name: \(String(exhibition!.exhibitionLat))"

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        databaseController?.removeListener(listener: self)
    }
    
    
    
    func onExhibitionPlantsChange(change: DatabaseChange, exhibitionPlants: [Plant]) {
        currentPlant = exhibitionPlants
    }
    
    func onPlantListChange(change: DatabaseChange, plants: [Plant]) {
        
    }
    
    func onExhibitionChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        exhibition = exhibitions[9]
        databaseController?.setDefaultExhibit(name: exhibition!.name ?? "")
        defaultExhibitionName = "\(exhibition!.name ?? "")"
        print(defaultExhibitionName)
        currentPlant = exhibition?.plants?.allObjects as! [Plant]
    }
}

extension ExhibitionDetailsViewController: UITableViewDataSource, UITableViewDelegate{
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
