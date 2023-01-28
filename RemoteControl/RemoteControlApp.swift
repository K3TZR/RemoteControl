//
//  RemoteControlApp.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/21/23.
//

import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    // disable tab view
    NSWindow.allowsAutomaticWindowTabbing = false
  }
    
  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    true
  }
}

@main
struct RemoteControlApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self)
  var appDelegate

  @StateObject var deviceModel = DeviceModel()
  @StateObject var relaysModel = RelaysModel()

  var body: some Scene {
    WindowGroup {
      DeviceControlView()
        .environment(\.managedObjectContext, deviceModel.container.viewContext)
        .environmentObject(deviceModel)
        .environmentObject(relaysModel)
    }
    .windowStyle(.hiddenTitleBar)

    Settings {
      SettingsView()
        .environment(\.managedObjectContext, deviceModel.container.viewContext)
        .environmentObject(deviceModel)
        .environmentObject(relaysModel)
    }
    .windowStyle(.hiddenTitleBar)
    .windowResizability(WindowResizability.contentSize)
    .defaultPosition(.topLeading)
  }
}
