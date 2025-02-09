//
//  Plant+CoreDataProperties.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 5/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//
//

import Foundation
import CoreData


extension Plant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plant> {
        return NSFetchRequest<Plant>(entityName: "Plant")
    }

    @NSManaged public var family: String?
    @NSManaged public var imageOfPlant: String?
    @NSManaged public var name: String?
    @NSManaged public var scientificName: String?
    @NSManaged public var yearDiscovered: Int64
    @NSManaged public var exhibitions: NSSet?

}

// MARK: Generated accessors for exhibitions
extension Plant {

    @objc(addExhibitionsObject:)
    @NSManaged public func addToExhibitions(_ value: Exhibition)

    @objc(removeExhibitionsObject:)
    @NSManaged public func removeFromExhibitions(_ value: Exhibition)

    @objc(addExhibitions:)
    @NSManaged public func addToExhibitions(_ values: NSSet)

    @objc(removeExhibitions:)
    @NSManaged public func removeFromExhibitions(_ values: NSSet)

}
