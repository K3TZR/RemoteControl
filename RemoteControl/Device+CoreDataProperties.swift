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

extension Device : Identifiable {

}
