//
//  DatabaseProtocol.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 2/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case exhibition
    case plants
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onExhibitionChange(change: DatabaseChange, exhibitionPlants: [Plant])
    func onPlantListChange(change: DatabaseChange, plants: [Plant])
}

protocol DatabaseProtocol: AnyObject {
    var defaultExhibition: [Exhibition] {get}
    
    func cleanup()
    func addPlant(name: String, family: String, imageOfPlant: String, scientificName: String, yearDiscovered: Int16) -> Plant
    func addExhibition(name: String, desc: String, exhibitionLat: Double, exhibitionLon: Double, icon: String) -> Exhibition
    func addPlantToExhibit(plant: Plant, exhibition: Exhibition) -> Bool
    func deletePlant(plant: Plant)
    func deleteExhibition(exhibition: Exhibition)
    func removePlantFromExhibition(plant: Plant, exhibition: Exhibition)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
