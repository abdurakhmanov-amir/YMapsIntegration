//
//  AddressEntity+CoreDataProperties.swift
//  
//
//  Created by Amir on 20.03.2025.
//
//

import Foundation
import CoreData


extension AddressEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddressEntity> {
        return NSFetchRequest<AddressEntity>(entityName: "AddressEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var address: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double

}
