//
//  CoreDataController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 2/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, NSFetchedResultsControllerDelegate, DatabaseProtocol {


    
    let DEFAULT_EXHIBITION_NAME = "Default Exhibition"
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    var allPlantsFetchResultsController: NSFetchedResultsController<Plant>?
    var exhibitionPlantsFetchedResultsController: NSFetchedResultsController<Plant>?
    var allExhibitionsFetchResultsContrller: NSFetchedResultsController<Exhibition>?
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "Royal-Botanic-Exhibitor")
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load Core data stack: \(error)")
            }
        }
        
        super.init()
            
        if fetchAllPlants().count == 0 {
            createDefaultEntries()
            
        }
        
        if fetchAllExhibitions().count == 0 {
            print("Hoyse naki??")
            createDefaultEntries2()
        }
        
        
        
    }
    
    // MARK: - Lazy Initialization of Default team
    lazy var defaultExhibition: [Exhibition] = {
        print("Hocchey na")
        var exhibitions = [Exhibition] ()
        
        let request: NSFetchRequest<Exhibition> = Exhibition.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", DEFAULT_EXHIBITION_NAME)
        request.predicate = predicate
        
        do {
            try exhibitions = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request Failed: \(error)")
        }
        
        print("Hocchey na")
        
        if exhibitions.count == 0 {
            print("Hocchey?")
            return [addExhibition(name: DEFAULT_EXHIBITION_NAME, desc: "Default Description", exhibitionLat: 121212.1212, exhibitionLon: 1212.1212, icon: "Default ICON")]
        }
        
        return exhibitions
        
    }()
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save to CoreData: \(error)")
            }
        }
    }
    
    // MARK: - Database Protocol Functions
    
    func cleanup() {
        saveContext()
    }
    
    func addPlant(name: String, family: String, imageOfPlant: String, scientificName: String, yearDiscovered: Int16) -> Plant {
        let plant = NSEntityDescription.insertNewObject(forEntityName: "Plant", into: persistentContainer.viewContext) as! Plant
        
        plant.name = name
        plant.family = family
        plant.imageOfPlant = imageOfPlant
        plant.scientificName = scientificName
        plant.yearDiscovered = yearDiscovered

        return plant
    }
    
    func addExhibition(name: String, desc: String, exhibitionLat: Double, exhibitionLon: Double, icon: String) -> Exhibition {
        let exhibition = NSEntityDescription.insertNewObject(forEntityName: "Exhibition", into: persistentContainer.viewContext) as! Exhibition
        
        exhibition.name = name
        exhibition.desc = desc
        exhibition.exhibitionLat = exhibitionLat
        exhibition.exhibitionLon = exhibitionLon
        exhibition.icon = icon

        return exhibition
        
    }
    
    func addPlantToExhibit(plant: Plant, exhibition: Exhibition) -> Bool {
        guard let plants = exhibition.plants, plants.contains(plant) == false, plants.count < 3 else {
                return false
            }
        
        exhibition.addToPlants(plant)
        return true
    }

    func deletePlant(plant: Plant) {
        persistentContainer.viewContext.delete(plant)
    }
    
    func deleteExhibition(exhibition: Exhibition) {
        persistentContainer.viewContext.delete(exhibition)
    }
    
    func removePlantFromExhibition(plant: Plant, exhibition: Exhibition) {
        exhibition.removeFromPlants(plant)
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .exhibition || listener.listenerType == .all {
            listener.onExhibitionChange(change: .update, exhibitionPlants: fetchFromExhibitPlants())
        }
        
        if listener.listenerType == .plants || listener.listenerType == .all {
            listener.onPlantListChange(change: .update, plants: fetchAllPlants())
        }
        
    }
    
    func removeListener(listener: DatabaseListener) {
        saveContext()
        listeners.removeDelegate(listener)
        
    }

    // MARK: - Fetched Results Controller Protocol Functions
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        if controller == allPlantsFetchResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .plants || listener.listenerType == .all {
                    listener.onPlantListChange(change: .update, plants: fetchAllPlants())
                }
            }
        } else if controller == exhibitionPlantsFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .exhibition  || listener.listenerType == .all {
                    listener.onExhibitionChange(change: .update, exhibitionPlants: fetchFromExhibitPlants())
                }
            }
        }
    }
    
    // MARK: - Core Data Fetch Requests
    
    func fetchAllExhibitions() -> [Exhibition] {
        
        if allExhibitionsFetchResultsContrller == nil {
            let fetchRequest: NSFetchRequest<Exhibition> = Exhibition.fetchRequest()
            
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            allExhibitionsFetchResultsContrller = NSFetchedResultsController<Exhibition>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            allExhibitionsFetchResultsContrller?.delegate = self
            
            do {
                try allExhibitionsFetchResultsContrller?.performFetch()
            } catch {
                print("Fetch Requst Failed: \(error)")
            }
        }
        
        var exhibitions = [Exhibition]()
        
        if allExhibitionsFetchResultsContrller?.fetchedObjects != nil {
            exhibitions = (allExhibitionsFetchResultsContrller?.fetchedObjects)!
        }
        return exhibitions
    }
    
    func fetchAllPlants() -> [Plant] {
        
        if allPlantsFetchResultsController == nil {
            let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
            
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            allPlantsFetchResultsController = NSFetchedResultsController<Plant>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            allPlantsFetchResultsController?.delegate = self
            
            do {
                try allPlantsFetchResultsController?.performFetch()
            } catch {
                print("Fetch Requst Failed: \(error)")
            }
        }
        
        var plants = [Plant]()
        
        if allPlantsFetchResultsController?.fetchedObjects != nil {
            plants = (allPlantsFetchResultsController?.fetchedObjects)!
        }
        return plants
    }
    
    func fetchFromExhibitPlants() -> [Plant] {
        if exhibitionPlantsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
            
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            let predicate = NSPredicate(format: "ANY exhibitions.name == %@", DEFAULT_EXHIBITION_NAME)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            fetchRequest.predicate = predicate
            
            exhibitionPlantsFetchedResultsController = NSFetchedResultsController<Plant>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            exhibitionPlantsFetchedResultsController?.delegate = self
            
            do {
                try exhibitionPlantsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Requst Failed: \(error)")
            }
        }
        
        var plants = [Plant]()
        
        if exhibitionPlantsFetchedResultsController?.fetchedObjects != nil {
            plants = (exhibitionPlantsFetchedResultsController?.fetchedObjects)!
        }
        return plants
    }
    
    func createDefaultEntries2() {
        let _ = addExhibition(name: "Exhibition A", desc: "Description A", exhibitionLat: 12.121212, exhibitionLon: 32.121212, icon: "Icon A")
    
        print("Ha hoyse")
    }
    
    func createDefaultEntries() {
        let _ = addPlant(name: "Plant A", family: "Plant Family A", imageOfPlant: "Imapge of Plant A", scientificName: "Scientific Name of Plant A", yearDiscovered: 1994)
        let _ = addPlant(name: "Plant B", family: "Plant Family B", imageOfPlant: "Imapge of Plant B", scientificName: "Scientific Name of Plant B", yearDiscovered: 1995)
        let _ = addPlant(name: "Plant C", family: "Plant Family C", imageOfPlant: "Imapge of Plant C", scientificName: "Scientific Name of Plant C", yearDiscovered: 1996)
        let _ = addPlant(name: "Plant D", family: "Plant Family D", imageOfPlant: "Imapge of Plant D", scientificName: "Scientific Name of Plant D", yearDiscovered: 1997)
        let _ = addPlant(name: "Plant E", family: "Plant Family E", imageOfPlant: "Imapge of Plant E", scientificName: "Scientific Name of Plant E", yearDiscovered: 1998)
        let _ = addPlant(name: "Plant F", family: "Plant Family F", imageOfPlant: "Imapge of Plant F", scientificName: "Scientific Name of Plant F", yearDiscovered: 1999)
        let _ = addPlant(name: "Plant G", family: "Plant Family G", imageOfPlant: "Imapge of Plant G", scientificName: "Scientific Name of Plant G", yearDiscovered: 2000)
        let _ = addPlant(name: "Plant H", family: "Plant Family H", imageOfPlant: "Imapge of Plant H", scientificName: "Scientific Name of Plant H", yearDiscovered: 2001)
        let _ = addPlant(name: "Plant I", family: "Plant Family I", imageOfPlant: "Imapge of Plant I", scientificName: "Scientific Name of Plant I", yearDiscovered: 2002)
    }
     
    
    
    
}

