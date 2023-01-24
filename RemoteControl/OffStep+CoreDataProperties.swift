//
//  OffStep+CoreDataProperties.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/23/23.
//
//

import Foundation
import CoreData


extension OffStep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OffStep> {
        return NSFetchRequest<OffStep>(entityName: "OffStep")
    }

    @NSManaged public var delay: Int16
    @NSManaged public var enabled: Bool
    @NSManaged public var newValue: Bool
    @NSManaged public var relayNumber: Int16
    @NSManaged public var device: Device?

}

extension OffStep : Identifiable {

}
