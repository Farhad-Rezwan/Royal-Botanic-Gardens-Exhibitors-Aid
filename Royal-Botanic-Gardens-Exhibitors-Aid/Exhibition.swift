//
//  Exhibition.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 22/8/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import Foundation

class Exhibition {
    var name: String?
    var description: String?
    var location: String?
    var plants: [Plant]?
    
    init(name: String, description: String, location: String, plants: [Plant]) {
        self.name = name
        self.description = description
        self.location = location
        self.plants = plants
    }
}
