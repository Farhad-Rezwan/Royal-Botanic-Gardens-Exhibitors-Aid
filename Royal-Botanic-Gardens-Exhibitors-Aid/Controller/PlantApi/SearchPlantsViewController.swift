//
//  SearchPlantsViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 17/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

/// Searches plants from the API
class SearchPlantsViewController: UIViewController, UISearchBarDelegate {
    
    let CELL_PLANT_API = "plantCell"
    let REQUEST_STRING = "https://trefle.io/api/v1/plants/search?token=3BaewBFyWrnF5TSE3pqwotZMns2uW31gU1J29DaEGOs&q="
    var indicator = UIActivityIndicatorView()
    var newPlant = [PlantData]()
    weak var databaseController: DatabaseProtocol?
    
    
    @IBOutlet weak var searchPlantsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchPlantsTableView.dataSource = self
        searchPlantsTableView.delegate = self
        
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for card"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.searchPlantsTableView.center
        self.view.addSubview(indicator)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText.count > 0 else {
            return
        }
        
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        
        newPlant.removeAll()
        searchPlantsTableView.reloadData()
        requestPlant(plantName: searchText)
        
    }
    
    /// makes request 
    func requestPlant(plantName: String) {
        let searchString = REQUEST_STRING + plantName
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        let task = URLSession.shared.dataTask(with: jsonURL!) { (data, respone, error) in
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                
            }
            if let error = error {
                print(error)
            }

            do {
                let decoder = JSONDecoder()
                let volumeData = try decoder.decode(VolumeData.self, from: data!)

                if let plant = volumeData.plant{
                    self.newPlant.append(contentsOf: plant)

                    DispatchQueue.main.sync {
                        self.searchPlantsTableView.reloadData()
                    }
                }
            } catch let err{
                print(err)
            }
        }
        task.resume()
    }
    

}

extension SearchPlantsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newPlant.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_PLANT_API, for: indexPath)
        let plant = newPlant[indexPath.row]
        
        cell.textLabel?.text = plant.name
        cell.detailTextLabel?.text = plant.family
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plant = newPlant[indexPath.row]
        
        let _ = databaseController?.addPlantFromAPI(plantData: plant)
        databaseController?.cleanup()
        navigationController?.popViewController(animated: true)
    }
    
    
}
