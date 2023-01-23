//
//  RemoteControlApp.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/21/23.
//

import CoreData
import SwiftUI

@main
struct RemoteControlApp: App {
  
  @StateObject var dataController : DataController
  
  init() {
    let dataController = DataController()
    _dataController = StateObject(wrappedValue: dataController)
  }
  
  var body: some Scene {
    WindowGroup {
      ParentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .environmentObject(dataController)
    }
  }
}
