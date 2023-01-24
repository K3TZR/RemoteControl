//
//  ContentView.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/21/23.
//

import SwiftUI

struct ParentView: View {
  @EnvironmentObject var dataController : DataController

  @Environment(\.managedObjectContext) var moc
  @FetchRequest(sortDescriptors: [ SortDescriptor(\.name),]) var devices: FetchedResults<Device>
  
  @State var selectedDevice: Device? = nil

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
            .onTapGesture {
              addNewDevice()
            }
          Image(systemName: "minus.rectangle")
            .onTapGesture {
              if selectedDevice != nil {
                deleteDevice(selectedDevice!)
              }
            }

        }.font(.title2)
      }
    } detail: {
      if selectedDevice != nil {
        DetailView(device: selectedDevice!)

      } else {
        VStack {
          Spacer()
          Text("Select a Device")
          Spacer()
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .navigation) {
        Button("Add Sample Data") {
          dataController.createSampleData()
        }
      }
    }
    .padding()
  }
  
  func deleteDevice(_ device: Device) {
    selectedDevice = nil
    moc.delete(device)
    try? moc.save()
  }
  
  func addNewDevice() {
    let newDevice = Device(context: moc)
    newDevice.id = UUID()
    newDevice.title = "NewDevice"
    newDevice.name = "NewName"
    
    var relays = [Relay]()
    for i in 1...8 {
      let newRelay = Relay(context: moc)
      newRelay.number = Int16(i)
      newRelay.usage = "---"
      newRelay.locked = false
      newRelay.device = newDevice
      relays.append(newRelay)
    }
    
    let onSteps = [OnStep]()
    for i in 1...8 {
      let newStep = OnStep(context: moc)
      newStep.enabled = false
      newStep.relayNumber = Int16(i)
      newStep.newValue = false
      newStep.delay = Int16(2)
    }

    let offSteps = [OffStep]()
    for i in 1...8 {
      let newStep = OffStep(context: moc)
      newStep.enabled = false
      newStep.relayNumber = Int16(i)
      newStep.newValue = false
      newStep.delay = Int16(2)
    }

    newDevice.relayArray = relays
    newDevice.onStepsArray = onSteps
    newDevice.offStepsArray = offSteps

    try? moc.save()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ParentView()
  }
}
