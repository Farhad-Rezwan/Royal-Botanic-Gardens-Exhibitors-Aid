//
//  EditPlantDelegate.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 5/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import Foundation

protocol EditPlantDelegate: AnyObject {
    func sendPlantToEdit(plant: Plant) -> Plant
}
