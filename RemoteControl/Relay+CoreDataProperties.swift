//
//  Relay+CoreDataProperties.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/23/23.
//
//

import Foundation
import CoreData


extension Relay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Relay> {
        return NSFetchRequest<Relay>(entityName: "Relay")
    }

    @NSManaged public var usage: String?
    @NSManaged public var number: Int16
    @NSManaged public var locked: Bool
    @NSManaged public var device: Device?

}

extension Relay : Identifiable {

}
