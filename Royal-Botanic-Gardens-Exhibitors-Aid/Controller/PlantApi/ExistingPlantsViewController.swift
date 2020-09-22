//
//  ExistingPlantsViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 17/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit


protocol SelectedPlantsDelegate {
    func addPlants(plants: [Plant])
}

/// All the plants that are there in core data are listed
class ExistingPlantsViewController: UIViewController, DatabaseListener, URLSessionTaskDelegate, URLSessionDownloadDelegate{
    

    var listenerType: ListenerType = .all
    var tempImage: [UIImage] = []
    var delegate: SelectedPlantsDelegate?

    @IBOutlet weak var existingPlantsTableView: UITableView!
    let PLANT_CELL = "showPlantDetailsCell"
    var allPlant: [Plant] = []
    var selectedPlantsForNewExhibition: [Plant] = []
    
    weak var databaseController: DatabaseProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        existingPlantsTableView.dataSource = self
        existingPlantsTableView.delegate = self

        
        existingPlantsTableView.allowsMultipleSelection = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    
    
    // MARK: - DatabaseListener methods
    func onExhibitionPlantsChange(change: DatabaseChange, exhibitionPlants: [Plant]) {
        // nothing done
    }
    
    func onPlantListChange(change: DatabaseChange, plants: [Plant]) {
        allPlant = plants
        existingPlantsTableView.reloadData()
    }
    
    func onExhibitionChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        // nothhing done
    }
    
    
    // MARK: - Add plants button action
    
    /// Add plants button
    ///  validates wheter atleast 3 palnts are added or not
    /// - Parameter sender: any
    @IBAction func addPlantsButton(_ sender: Any) {
        if selectedPlantsForNewExhibition.count >= 3 {
            delegate?.addPlants(plants: selectedPlantsForNewExhibition)

            self.navigationController?.popViewController(animated: true)
            return
        }
        var errorMessage = ""
        
        if selectedPlantsForNewExhibition.count < 3 {
            errorMessage += "-plese select atleast 3 plants\n"
        }

        displayMessage(title: "Must select atleast 3 plants", message: errorMessage)
    }
    
    /// Displays Alert for invalid infomation
    /// - Parameters:
    ///   - title: the title of the alert
    ///   - message: message of the allert
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    // MARK: - URL session methods
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        do {
        let data = try Data(contentsOf: location)
        // Images can only be loaded from the main thread
            DispatchQueue.main.async {
                self.tempImage.append(UIImage(data: data)!)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite > 0 {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            debugPrint("Progress \(downloadTask) \(progress)")
        }
    }
    
    
}


extension ExistingPlantsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPlant.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PLANT_CELL, for: indexPath) as! PlantTableViewCell
        let plant = allPlant[indexPath.row]

        cell.setupPlant(plant: plant)

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PlantTableViewCell else { return }
        redraw(selectedCell: cell)
        
        self.selectDeselectCell(tableView: tableView, indexPath: indexPath)
        
        print("select")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PlantTableViewCell else { return }
        redraw(deselectedCell: cell)
        
        self.selectDeselectCell(tableView: tableView, indexPath: indexPath)
        print("deselect")
    }
    
    
    
    /// helps to make the cell selected with border
    private func redraw(selectedCell cell: PlantTableViewCell
            ) {
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = cell.bounds.height / 2
        cell.layer.borderColor = UIColor.systemGroupedBackground.cgColor

        }

        private func redraw(deselectedCell cell: PlantTableViewCell) {
            cell.layer.borderWidth = 0.0
            cell.layer.cornerRadius = 0.0

        }

}

/// reference: https://www.youtube.com/watch?v=xkC0nJVjRWk
/// helps to keep the selected cell and selected plants in selectedPlantsForNewExhibition array
extension ExistingPlantsViewController {
    // select and deselect table view
    
    
    /// helps to keep the selected cell and selected plants in selectedPlantsForNewExhibition array
    /// - Parameters:
    ///   - tableView: current table view
    ///   - indexPath: IndexPath
    func selectDeselectCell(tableView: UITableView, indexPath: IndexPath) {
        selectedPlantsForNewExhibition.removeAll()
        
        if let array = existingPlantsTableView.indexPathsForSelectedRows {
            
            for index in array {
                selectedPlantsForNewExhibition.append(allPlant[index.row])
            }
        }
    }
}
