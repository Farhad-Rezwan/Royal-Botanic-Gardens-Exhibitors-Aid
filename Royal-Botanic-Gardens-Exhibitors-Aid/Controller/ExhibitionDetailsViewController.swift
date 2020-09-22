//
//  ExhibitionDetailsViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/8/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit
import MapKit

/// class for exhibition details
class ExhibitionDetailsViewController: UIViewController, DatabaseListener {
    
    var defaultExhibitionName: String = ""
    
    var listenerType: ListenerType = .all
    
    var locationAnnotation: LocationAnnotation?
    
    
    
    @IBOutlet weak var exhibitDescriptionLabel: UILabel!
    @IBOutlet weak var exhibitionIconImageView: UIImageView!
    @IBOutlet weak var exhibitionIconBackgroundView: UIView!
    @IBOutlet weak var plantsTableView: UITableView!
    @IBOutlet weak var showLocationButtonUI: UIButton!
    
    var currentPlant: [Plant] = []
    var exhibition: Exhibition?
    
    
    weak var databaseController: DatabaseProtocol?
    

    override func viewDidLoad() {
        title = exhibition?.name
        
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        plantsTableView.delegate = self
        plantsTableView.dataSource = self
        
        
        // setting UI
        exhibitionIconBackgroundView.layer.borderWidth = 2.0
        exhibitionIconBackgroundView.layer.cornerRadius = exhibitionIconBackgroundView.bounds.height / 2
        exhibitionIconBackgroundView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        showLocationButtonUI.layer.borderWidth = 2.0
        showLocationButtonUI.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        showLocationButtonUI.layer.cornerRadius = 20
        exhibitDescriptionLabel.layer.cornerRadius = 10
        plantsTableView.layer.cornerRadius = 20
        exhibitDescriptionLabel.layer.borderWidth = 1.0
        plantsTableView.layer.borderWidth = 1.0
        exhibitDescriptionLabel.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        plantsTableView.layer.borderColor = UIColor.systemGroupedBackground.cgColor

    }
    
    override func viewWillAppear(_ animated: Bool) {
        databaseController?.addListener(listener: self)
        
        
        if exhibition != nil {
            exhibitDescriptionLabel.text = "Summary: \(exhibition!.desc ?? "Nil")"
            
            // setting the icon
            let newIcon = Icon(imageIconName: exhibition!.icon ?? "imageLoad")
            exhibitionIconImageView.image = UIImage(named: newIcon.imageIconName)
            exhibitionIconBackgroundView.backgroundColor = newIcon.iconTintColor
            plantsTableView.reloadData()

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        databaseController?.removeListener(listener: self)
    }
    
    
    @IBAction func showLocation(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func onExhibitionPlantsChange(change: DatabaseChange, exhibitionPlants: [Plant]) {
        currentPlant = exhibitionPlants
    }
    
    func onPlantListChange(change: DatabaseChange, plants: [Plant]) {
        
    }
    
    func onExhibitionChange(change: DatabaseChange, exhibitions: [Exhibition]) {
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
