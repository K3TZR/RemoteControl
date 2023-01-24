//
//  OnStep+CoreDataProperties.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/24/23.
//
//

import Foundation
import CoreData


extension OnStep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OnStep> {
        return NSFetchRequest<OnStep>(entityName: "OnStep")
    }

    @NSManaged public var relayNumber: Int16
    @NSManaged public var enabled: Bool
    @NSManaged public var newValue: Bool
    @NSManaged public var delay: Int16
    @NSManaged public var stepNumber: Int16
    @NSManaged public var device: Device?

}

extension OnStep : Identifiable {

}
