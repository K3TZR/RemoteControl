//
//  DataModel.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/21/23.
//
import CoreData
import Foundation
import SwiftUI

class DeviceModel: ObservableObject {
  let container = NSPersistentContainer(name: "Devices")

  init() {
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Core Data failed to load: \(error.localizedDescription)")
      }
    }
  }
  
  func addDevice(save: Bool = true) -> Device {
    // create the device
    let newDevice = Device(context: container.viewContext)
    newDevice.id = UUID()
    newDevice.name = "NewDevice"
    newDevice.title = "Title"
    newDevice.ipAddress = ""
    newDevice.user = ""
    newDevice.password = ""
    newDevice.showEmptyNames = true

    // create the locks
    for i in 1...8 {
      let lock = Lock(context: container.viewContext)
      lock.lockNumber = Int16(i)
      lock.value = false
      lock.device = newDevice
    }
    // create the Cycle On Stepa
    for i in 1...8 {
      let step = OnStep(context: container.viewContext)
      step.enabled = false
      step.relayNumber = Int16(i)
      step.stepNumber = Int16(i)
      step.newValue = false
      step.delay = Int16(2)
      step.device = newDevice
    }
    // create the Cycle Off Stepa
    for i in 1...8 {
      let step = OffStep(context: container.viewContext)
      step.enabled = false
      step.relayNumber = Int16(i)
      step.stepNumber = Int16(i)
      step.newValue = false
      step.delay = Int16(2)
      step.device = newDevice
    }

    if save {
      do {
        try container.viewContext.save()
      }
      catch {
        fatalError("Unable to load sample data: \(error.localizedDescription)")
      }
    }
    return newDevice
  }

  func toggleLock(_ device: Device, _ relayNumber: Int) {
    // rewrite the array to force a redraw in the DeviceControlView
    var currentLocks = device.locksArray
    currentLocks[relayNumber - 1].value.toggle()
    device.locksArray = currentLocks
    save()
  }
  
  func save() {
    // only save if changed
    if container.viewContext.hasChanges {
      do {
        try container.viewContext.save()
      }
      catch {
        // something VERY BAD happened
        fatalError("Unable to save data: \(error.localizedDescription)")
      }
    }
  }
  
  func delete(_ object: NSManagedObject) {
    container.viewContext.delete(object)
    save()
  }
  
  func deleteAll() {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Device.fetchRequest()
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    _ = try? container.viewContext.execute(batchDeleteRequest)
    save()
  }
}
