//
//  AllExhibitionsTableViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/8/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit
import MapKit

class AllExhibitionsTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener{
    
    weak var mapViewController: MapViewController?
    var locationList = [LocationAnnotation]()
    
    
    
    var defaultExhibitionName: String = ""
    

    
    var exhibitions: [Exhibition] = []
    var tempExhibitions: [Exhibition] = []
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadLocation()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        tempExhibitions = exhibitions
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Exhibitions"
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        if searchText.count > 0 {
            tempExhibitions = exhibitions.filter({(exhibition: Exhibition) -> Bool in
                guard let name = exhibition.name else {
                    return false
                }
                return name.lowercased().contains(searchText)
            })
        } else {
            tempExhibitions = exhibitions
        }

        tableView.reloadData()
        
        
    }
    
   
    
    func loadLocation() {
        var location = LocationAnnotation(title: "Monash University - Caulfield", subtitle: "The Caulfield campus of the University", lat: -37.877623, lon: 145.045374)
        locationList.append(location)
        
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(title: "Monash University - Clayton", subtitle: "The Clayton campus of the University", lat: -37.9105238, lon: 145.1362182)
        
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
    }
    
    
    
//    func createExhibition() -> [Exhibition] {
//        var tempExhibitions: [Exhibition] = []
//
//        let exhibition1 = Exhibition(name: "I dont care exhibition", description: "I realy dont care", icon: "No Icon")
//        let exhibition2 = Exhibition(name: "You dont care exhibition", description: "You realy dont care", icon: "Not sure ICON")
//        let exhibition3 = Exhibition(name: "We dont care exhibition", description: "We realy dont care", icon: "Unknown ICON")
//
//        tempExhibitions.append(contentsOf: [exhibition1, exhibition2, exhibition3])
//
//
//        return tempExhibitions
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tempExhibitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exhibitionCell = tableView.dequeueReusableCell(withIdentifier: "exhibitionCell") as! AllExhibitionsTableViewCell
        let exhibition = tempExhibitions[indexPath.row]
        
        exhibitionCell.setupExhibition(exhibition: exhibition)
        
        
        
        return exhibitionCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapViewController?.focusOn(annotation: self.locationList[indexPath.row])
        
        if let mapVC = mapViewController {
            splitViewController?.showDetailViewController(mapVC, sender: nil)
        }
    }
    
    
    func onExhibitionChange(change: DatabaseChange, exhibitions: [Exhibition]) {
           self.exhibitions = exhibitions
           updateSearchResults(for: navigationItem.searchController!)
       }
       
       func onExhibitionPlantsChange(change: DatabaseChange, exhibitionPlants: [Plant]) {
           // do nothing
       }
       
       func onPlantListChange(change: DatabaseChange, plants: [Plant]) {
           // do nothing
       }
    
    
    
    
    
    
    // MARK: - New Location Delegate Function
    
    func locationAnnotationAdded(annotation: LocationAnnotation) {
        locationList.append(annotation)
        tableView.insertRows(at: [IndexPath(row: locationList.count - 1, section: 0)], with: .automatic)
        mapViewController?.mapView.addAnnotation(annotation)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
