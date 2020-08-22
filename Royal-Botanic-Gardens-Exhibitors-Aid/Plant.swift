//
//  Plant.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/8/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import Foundation

class Plant {
    var name: String?
    var scientificName: String?
    var yearDiscovered: Int?
    var family: String?
    var imageURL: String?
    
    init (name: String, scientificName: String, yearDiscovered: Int, family: String, imageURL: String) {
        self.name = name
        self.scientificName = scientificName
        self.yearDiscovered = yearDiscovered
        self.family = family
        self.imageURL = imageURL
    }
}
