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
    
    let device1 = Device(context: viewContext)
    device1.id = UUID()
    device1.name = "DIN4 Relay"
    device1.title = "K3TZR Relay Control"
    device1.ipAddress = "192.168.1.220"
    device1.user = "admin"
    device1.password = "ruwn1viwn_RUF_zolt"
    device1.showEmptyNames = true

    let device2 = Device(context: viewContext)
    device2.id = UUID()
    device2.name = "Web Power Switch"
    device2.title = "K3TZR Outlet Control"
    device2.ipAddress = "192.168.1.221"
    device2.user = "admin"
    device2.password = "8PsCVECFUeyg3Atcq3ZB"
    device2.showEmptyNames = true

    let relay11 = Relay(context: viewContext)
    relay11.usage = "Main AC Power"
    relay11.locked = true
    relay11.device = device1
    relay11.number = 1

    let relay12 = Relay(context: viewContext)
    relay12.usage = "Radio Power Supply"
    relay12.locked = false
    relay12.device = device1
    relay12.number = 2

    let relay13 = Relay(context: viewContext)
    relay13.usage = "---"
    relay13.locked = false
    relay13.device = device1
    relay13.number = 3

    let relay14 = Relay(context: viewContext)
    relay14.usage = "---"
    relay14.locked = false
    relay14.device = device1
    relay14.number = 4

    let relay15 = Relay(context: viewContext)
    relay15.usage = "Ethernet Switch"
    relay15.locked = false
    relay15.device = device1
    relay15.number = 5

    let relay16 = Relay(context: viewContext)
    relay16.usage = "---"
    relay16.locked = false
    relay16.device = device1
    relay16.number = 6

    let relay17 = Relay(context: viewContext)
    relay17.usage = "---"
    relay17.locked = false
    relay17.device = device1
    relay17.number = 7

    let relay18 = Relay(context: viewContext)
    relay18.usage = "Remote ON"
    relay18.locked = true
    relay18.device = device1
    relay18.number = 8

    // ---------------------------------------------
    
    let relay21 = Relay(context: viewContext)
    relay21.usage = "Main AC Power"
    relay21.locked = true
    relay21.device = device2
    relay21.number = 1

    let relay22 = Relay(context: viewContext)
    relay22.usage = "---"
    relay22.locked = false
    relay22.device = device2
    relay22.number = 2

    let relay23 = Relay(context: viewContext)
    relay23.usage = "Rotator Control"
    relay23.locked = false
    relay23.device = device2
    relay23.number = 3

    let relay24 = Relay(context: viewContext)
    relay24.usage = "Antenna Switch"
    relay24.locked = false
    relay24.device = device2
    relay24.number = 4

    let relay25 = Relay(context: viewContext)
    relay25.usage = "---"
    relay25.locked = false
    relay25.device = device2
    relay25.number = 5

    let relay26 = Relay(context: viewContext)
    relay26.usage = "WiFi Router"
    relay26.locked = false
    relay26.device = device2
    relay26.number = 6

    let relay27 = Relay(context: viewContext)
    relay27.usage = "Radio Power Supply"
    relay27.locked = false
    relay27.device = device2
    relay27.number = 7

    let relay28 = Relay(context: viewContext)
    relay28.usage = "Remote ON"
    relay28.locked = false
    relay28.device = device2
    relay28.number = 8


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
  
//  static var preview : DataController = {
//    let dataController = DataController()
//    let viewContext = dataController.container.viewContext
//
//    dataController.createSampleData()
//    return dataController
//  }()
  
}
