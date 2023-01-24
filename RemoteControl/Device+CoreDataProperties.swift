//
//  Device+CoreDataProperties.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/23/23.
//
//

import Foundation
import CoreData


extension Device {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Device> {
        return NSFetchRequest<Device>(entityName: "Device")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var ipAddress: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var showEmptyNames: Bool
    @NSManaged public var title: String?
    @NSManaged public var user: String?
    @NSManaged public var relays: NSSet?
    @NSManaged public var onSteps: NSSet?
    @NSManaged public var offSteps: NSSet?

}

// MARK: Generated accessors for relays
extension Device {

    @objc(addRelaysObject:)
    @NSManaged public func addToRelays(_ value: Relay)

    @objc(removeRelaysObject:)
    @NSManaged public func removeFromRelays(_ value: Relay)

    @objc(addRelays:)
    @NSManaged public func addToRelays(_ values: NSSet)

    @objc(removeRelays:)
    @NSManaged public func removeFromRelays(_ values: NSSet)

}

// MARK: Generated accessors for onSteps
extension Device {

    @objc(addOnStepsObject:)
    @NSManaged public func addToOnSteps(_ value: OnStep)

    @objc(removeOnStepsObject:)
    @NSManaged public func removeFromOnSteps(_ value: OnStep)

    @objc(addOnSteps:)
    @NSManaged public func addToOnSteps(_ values: NSSet)

    @objc(removeOnSteps:)
    @NSManaged public func removeFromOnSteps(_ values: NSSet)

}

// MARK: Generated accessors for offSteps
extension Device {

    @objc(addOffStepsObject:)
    @NSManaged public func addToOffSteps(_ value: OffStep)

    @objc(removeOffStepsObject:)
    @NSManaged public func removeFromOffSteps(_ value: OffStep)

    @objc(addOffSteps:)
    @NSManaged public func addToOffSteps(_ values: NSSet)

    @objc(removeOffSteps:)
    @NSManaged public func removeFromOffSteps(_ values: NSSet)

}

extension Device : Identifiable {

}
