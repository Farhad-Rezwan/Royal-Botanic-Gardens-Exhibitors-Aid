//
//  ParkData.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 17/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

class PlantData: NSObject, Decodable {
    var name: String?
    var family: String?
    var yearDiscovered: Int64?
    var scientificName: String?
    var imageOfPlant: String?
    
    private enum RootKeys: String, CodingKey {
        case name = "common_name"
        case family
        case yearDiscovered = "year"
        case scientificName = "scientific_name"
        case imageOfPlant = "image_url"
    }

    required init(from decoder: Decoder) throws {
        let plantContainer = try decoder.container(keyedBy: RootKeys.self)
        
        name = try plantContainer.decode(String.self, forKey: .name)
        family = try plantContainer.decode(String.self, forKey: .family)
        yearDiscovered = try? (plantContainer.decode(Int64.self, forKey: .yearDiscovered))
        scientificName = try plantContainer.decode(String.self, forKey: .scientificName)
        imageOfPlant = try? plantContainer.decode(String.self, forKey: .imageOfPlant)
        }

}
