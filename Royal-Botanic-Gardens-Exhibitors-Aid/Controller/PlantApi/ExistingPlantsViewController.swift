//
//  ExistingPlantsViewController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 17/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

class ExistingPlantsViewController: UIViewController, DatabaseListener, URLSessionTaskDelegate, URLSessionDownloadDelegate{
    
    
    var listenerType: ListenerType = .plants
    
    var tempImage: [UIImage] = []
    

    @IBOutlet weak var existingPlantsTableView: UITableView!
    let PLANT_CELL = "showPlantDetailsCell"
    var allPlant: [Plant] = []
    
    weak var databaseController: DatabaseProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        existingPlantsTableView.dataSource = self
        existingPlantsTableView.delegate = self
        
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
    
    
    func onExhibitionPlantsChange(change: DatabaseChange, exhibitionPlants: [Plant]) {
        //
    }
    
    func onPlantListChange(change: DatabaseChange, plants: [Plant]) {
        allPlant = plants
        existingPlantsTableView.reloadData()
    }
    
    func onExhibitionChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        //
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
        
//        let config = URLSessionConfiguration.background(withIdentifier: "avatarBoy")
//        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
//        let url = URL(string: plant.imageOfPlant!)!
//        let task = session.downloadTask(with: url) { (url, response, error) in
//            if let error = error {
//                print(error)
//            }
//            
//            DispatchQueue.main.async {
//                print(self.tempImage)
//            }
//           
//        }
//        task.resume()
        
        
        

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
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
        debugPrint("Progress \(downloadTask) \(progress)") }
    }
    
    
}
