//
//  Lock+CoreDataProperties.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/27/23.
//
//

import Foundation
import CoreData


extension Lock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lock> {
        return NSFetchRequest<Lock>(entityName: "Lock")
    }

    @NSManaged public var value: Bool
    @NSManaged public var lockNumber: Int16
    @NSManaged public var device: Device?

}

extension Lock : Identifiable {

}
