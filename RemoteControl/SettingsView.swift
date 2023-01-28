//
//  ContentView.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/21/23.
//

import SwiftUI

struct SettingsView: View {

  @State var selectedDevice: Device?

  @EnvironmentObject var relaysModel: RelaysModel
  @EnvironmentObject var coreDataModel : DeviceModel
  @FetchRequest(sortDescriptors: [ SortDescriptor(\.name),]) var devices: FetchedResults<Device>

  var body: some View {
    NavigationSplitView {
      List(devices, selection: $selectedDevice) { device in
        VStack(alignment: .leading) {
          Text(device.wrappedName).font(.headline)
          Text(device.wrappedTitle).foregroundColor(.secondary)
        }.tag(device)
      }
      VStack {
        HStack {
          Image(systemName: "plus.rectangle")
          // add a new Device
            .onTapGesture {
              _ = coreDataModel.addDevice()
            }
          Image(systemName: "minus.rectangle")
            .onTapGesture {
              delete()
            }
          
        }.font(.title2)
      }
      .onChange(of: selectedDevice) { newDevice in
        if let device = newDevice, device.name != "NewName" {
          relaysModel.relaysSync(device)
        }
      }
      
    } detail: {
      if devices.count == 0 {
        // ask the user to select a device
        VStack {
          Spacer()
          Text("ADD one or more Devices").font(.title)
          Spacer()
        }
        
      } else {
        if selectedDevice == nil {
          VStack {
            Spacer()
            Text("Select a Device")
            Spacer()
          }
        } else {
          SettingsDetailView(device: selectedDevice!)
//            .environmentObject(relaysModel)
            .environmentObject(coreDataModel)
        }
      }
    }
    .onDeleteCommand{
      delete()
    }
    .padding()
  }
  
  func delete() {
    // delete the selected Device
    if selectedDevice != nil {
      let device = selectedDevice!
      selectedDevice = nil
      coreDataModel.delete(device)
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var coreDataModel = DeviceModel()
  
  static var previews: some View {
    
    return SettingsView()
      .environment(\.managedObjectContext, coreDataModel.container.viewContext)
      .environmentObject(coreDataModel)
  }
}
