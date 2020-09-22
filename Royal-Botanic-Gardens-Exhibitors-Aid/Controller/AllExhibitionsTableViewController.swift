//
//  AllExhibitionsTableViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/8/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit
import MapKit

/// table view controller to store all exhibition details, is searchable and sortable
class AllExhibitionsTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener{
    
    weak var mapViewController: MapViewController?
    var locationList = [LocationAnnotation]()
    
    
    
    var defaultExhibitionName: String = ""
    

    
    var exhibitions: [Exhibition] = []
    var tempExhibitions: [Exhibition] = []
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .exhibition
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        

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
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    /// once search results are updated
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
        
        // to make sure that afer searching the lcoation is perfectly annoted
        loadLocation(exhibitions: tempExhibitions)
        tableView.reloadData()
    }
    
   
    
    /// Loads locations with respect to displaying in the table view.
    /// - Parameter exhibitions: Temporary exhibitions to show, depending on search results or all exhibitions before searching any.
    func loadLocation(exhibitions: [Exhibition]) {
        
        // to make sure that locations are not not duplicated
        locationList.removeAll()
        
        for item in exhibitions {
            let location = LocationAnnotation(title: item.name ?? "No name", subtitle: item.desc ?? "No Description", lat: item.exhibitionLat, lon: item.exhibitionLon, imageIcon: item.icon ?? " ", storeExhibition: item)
            locationList.append(location)
            mapViewController?.mapView.addAnnotation(location)
        }
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempExhibitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exhibitionCell = tableView.dequeueReusableCell(withIdentifier: "exhibitionCell") as! AllExhibitionsTableViewCell
        let exhibition = tempExhibitions[indexPath.row]
        
        exhibitionCell.setupExhibition(exhibition: exhibition)
        
        
        
        return exhibitionCell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapViewController?.focusOn(annotation: self.locationList[indexPath.row], regionInMeters: 200)
        
        if let mapVC = mapViewController {
            splitViewController?.showDetailViewController(mapVC, sender: nil)
        }
    }
    
    
    func onExhibitionChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        self.exhibitions = exhibitions
        tempExhibitions = exhibitions
        
        // Always called so that, consistency of all result verses searched results are maintained
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

}
