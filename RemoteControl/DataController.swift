//
//  DataModel.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/21/23.
//
import CoreData
import Foundation

class DataController: ObservableObject {
  let container = NSPersistentContainer(name: "Devices")
  
  init() {
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Core Data failed to load: \(error.localizedDescription)")
      }
    }
  }
  
  func createSampleData() {
    
    deleteAll()
    
    let viewContext = container.viewContext
    
    // ----- DIN Relay 4 Device -----
    
    let dinRelay = Device(context: viewContext)
    dinRelay.id = UUID()
    dinRelay.name = "DIN4 Relay"
    dinRelay.title = "K3TZR Relay Control"
    dinRelay.ipAddress = "192.168.1.220"
    dinRelay.user = "admin"
    dinRelay.password = "ruwn1viwn_RUF_zolt"
    dinRelay.showEmptyNames = true

    createRelays(dinRelay, viewContext)
    createOnSteps(dinRelay, viewContext)
    createOffSteps(dinRelay, viewContext)


    // ----- Web Power Switch Pro Device -----
    
    let powerSwitch = Device(context: viewContext)
    powerSwitch.id = UUID()
    powerSwitch.name = "Web Power Switch"
    powerSwitch.title = "K3TZR Outlet Control"
    powerSwitch.ipAddress = "192.168.1.221"
    powerSwitch.user = "admin"
    powerSwitch.password = "8PsCVECFUeyg3Atcq3ZB"
    powerSwitch.showEmptyNames = true

    createRelays(powerSwitch, viewContext)
    createOnSteps(powerSwitch, viewContext)
    createOffSteps(powerSwitch, viewContext)

    do {
      try viewContext.save()
    }
    catch {
      fatalError("Unable to load sample data: \(error.localizedDescription)")
    }
  }
  
  func save() {
    if container.viewContext.hasChanges {
      do {
        try container.viewContext.save()
      }
      catch {
        fatalError("Unable to save data: \(error.localizedDescription)")
      }
    }
  }
  
  func delete(_ object: NSManagedObject) {
    container.viewContext.delete(object)
  }
  
  func deleteAll() {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Device.fetchRequest()
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    _ = try? container.viewContext.execute(batchDeleteRequest)
  }
  
  func createRelays(_ device: Device, _ context: NSManagedObjectContext) {
    for i in 1...8 {
      let relay = Relay(context: context)
      relay.usage = "---"
      relay.locked = false
      relay.device = device
      relay.number = Int16(i)
    }
  }
  
  func createOnSteps(_ device: Device, _ context: NSManagedObjectContext)  {
    for i in 1...8 {
      let step = OnStep(context: context)
      step.enabled = false
      step.relayNumber = Int16(i)
      step.newValue = false
      step.delay = Int16(2)
      step.device = device
    }
  }

  func createOffSteps(_ device: Device, _ context: NSManagedObjectContext)  {
    for i in 1...8 {
      let step = OffStep(context: context)
      step.enabled = false
      step.relayNumber = Int16(i)
      step.newValue = false
      step.delay = Int16(2)
      step.device = device
    }
  }

  
  
  static var preview : DataController = {
    let dataController = DataController()
    let viewContext = dataController.container.viewContext

    dataController.createSampleData()
    return dataController
  }()
  
}
