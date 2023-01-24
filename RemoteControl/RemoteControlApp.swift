//
//  RemoteControlApp.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/21/23.
//

import SwiftUI

@main
struct RemoteControlApp: App {
  
  @StateObject var dataController = DataController()
  
  var body: some Scene {
    WindowGroup {
      ParentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .environmentObject(dataController)
    }
  }
}
