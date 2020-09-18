//
//  VolumeData.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 18/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

class VolumeData: NSObject, Decodable {
    var plant: [PlantData]?
    
    private enum CodingKeys: String, CodingKey {
    case plant = "data"
    }
}
