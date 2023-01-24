//
//  ContentView.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/21/23.
//

import SwiftUI

struct ParentView: View {

  @State var selectedDevice: Device? = nil

  @EnvironmentObject var dataController : DataController
  @FetchRequest(sortDescriptors: [ SortDescriptor(\.name),]) var devices: FetchedResults<Device>
    
  var body: some View {
    NavigationSplitView {
      List(devices, selection: $selectedDevice ) { device in
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
              _ = dataController.addDevice()
            }
          Image(systemName: "minus.rectangle")
            .onTapGesture {
              delete()
            }
          
        }.font(.title2)
      }
    } detail: {
      if selectedDevice != nil {
        // show the details if a device is selected
        DetailView(device: selectedDevice!)
        
      } else {
        // ask the user to select a device
        VStack {
          Spacer()
          if devices.count == 0 {
            Text("ADD one or more Devices").font(.title)
          } else {
            Text("Select a Device").font(.title)
          }
          Spacer()
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
      dataController.delete(device)
    }
  }
}

struct ParentView_Previews: PreviewProvider {
  static var dataController = DataController()
  
  static var previews: some View {
    
    return ParentView()
      .environment(\.managedObjectContext, dataController.container.viewContext)
      .environmentObject(dataController)
  }
}
