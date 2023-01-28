//
//  DeviceView.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/21/23.
//

import SwiftUI

struct SettingsDetailView: View {
  @ObservedObject var device: Device
  
  @AppStorage("deviceIndex") var deviceIndex: Int = -1

  @EnvironmentObject var deviceModel: DeviceModel
  @EnvironmentObject var relaysModel: RelaysModel
  
  var body: some View {
    VStack {
      DeviceParamsView(device: device)
      
      CyclesView(device: device)
      HStack {
        Spacer()
        Button("Save Device") { deviceModel.save() }
      }
      
      Divider().background(Color(.blue))
      RelaysView(relaysModel: relaysModel, device: device)
      
      HStack {
        Spacer()
        Button("Save Relays") { relaysModel.relaysUpdate(device) }
      }
    }
  }
}

private struct DeviceParamsView: View {
  @ObservedObject var device: Device

  var body: some View {
    HStack(spacing: 40) {
      
      Grid(alignment: .leading, horizontalSpacing: 40, verticalSpacing: 10) {
        GridRow {
          Text("Name")
          TextField("", text: $device.wrappedName)
        }
        GridRow {
          Text("Title")
          TextField("", text: $device.wrappedTitle)
        }
        GridRow {
          Text("User")
          TextField("", text: $device.wrappedUser)
        }
      }
      Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
        GridRow {
          Toggle("Show empty names", isOn: $device.showEmptyNames)
            .gridCellColumns(2)
        }
        GridRow {
          Text("IP Address")
          TextField("", text: $device.wrappedIpAddress)
        }
        GridRow {
          Text("Password")
          TextField("", text: $device.wrappedPassword)
        }
      }
    }
  }
}

private struct RelaysView: View {
  @ObservedObject var relaysModel: RelaysModel
  @ObservedObject var device: Device

  var body: some View {
    if relaysModel.relays.count == 0 || device.locksArray.count == 0 {
      VStack {
        Spacer()
        Text("Relays not available until Connected").font(.title).foregroundColor(.red)
        Spacer()
      }
    } else {
      HStack(spacing: 100) {
        
        Grid (verticalSpacing: 5) {
          GridRow {
            Text("#")
            Text("Usage")
            Text("Locked")
            Text("Disabled")
          }
          ForEach($relaysModel.relays) { $relay in
            if relay.number % 2 != 0 {
              GridRow {
                Text(String(relay.number) + ".")
                TextField("", text: $relay.name)
                Toggle("", isOn: $relay.isLocked)
                Toggle("", isOn: $device.locksArray[relay.number - 1].value)
              }.disabled(relay.isLocked)
            }
          }
        }.frame(width: 250)
        
        Grid (verticalSpacing: 5) {
          GridRow {
            Text("#")
            Text("Usage")
            Text("Locked")
            Text("Disabled")
          }
          ForEach($relaysModel.relays) { $relay in
            if relay.number % 2 == 0 {
              GridRow {
                Text(String(relay.number) + ".")
                TextField("", text: $relay.name)
                Toggle("", isOn: $relay.isLocked)
                Toggle("", isOn: $device.locksArray[relay.number - 1].value)
              }.disabled(relay.isLocked)
            }
          }
        }.frame(width: 250)
      }
    }
  }
}

private struct CyclesView: View {
  @ObservedObject var device: Device
  
  let relayChoices = [1,2,3,4,5,6,7,8]
  
  var body: some View {
    HStack(spacing: 250) {
      Text("Cycle ON")
      Text("Cycle OFF")
    }
    HStack(spacing: 80) {
      
      Grid (verticalSpacing: 5) {
        GridRow {
          Text("Enabled")
          Text("Step")
          Text("Relay")
          Text("Value")
          Text("Delay")
        }
        ForEach($device.onStepsArray, id: \.self) { $step in
          GridRow {
            Toggle("", isOn: $step.enabled)
            Group {
              Picker("", selection: $step.wrappedStepNumber) {
                ForEach(relayChoices, id: \.self) {
                  Text(String($0)).tag($0)
                }
              }
              .labelsHidden()
              .frame(width: 50)
              
              Text(String(step.relayNumber) + ".")
              Toggle("", isOn: $step.newValue)
              TextField("", value: $step.wrappedDelay, format: .number)
                .multilineTextAlignment(.trailing)
                .frame(width: 75)
            }.disabled(!step.enabled)
          }
        }
      }.frame(width: 240)
      
      Grid (verticalSpacing: 5) {
        GridRow {
          Text("Enabled")
          Text("Step")
          Text("Relay")
          Text("Value")
          Text("Delay")
        }
        ForEach($device.offStepsArray, id: \.self) { $step in
          GridRow {
            Toggle("", isOn: $step.enabled)
            Group {
              Picker("", selection: $step.wrappedStepNumber) {
                ForEach(relayChoices, id: \.self) {
                  Text(String($0)).tag($0)
                }
              }
              .labelsHidden()
              .frame(width: 50)
              
              Text(String(step.relayNumber) + ".")
              Toggle("", isOn: $step.newValue)
              TextField("", value: $step.wrappedDelay, format: .number)
                .multilineTextAlignment(.trailing)
                .frame(width: 75)
            }.disabled(!step.enabled)
          }
        }
      }.frame(width: 240)
    }
  }
}

struct SettingsDetailView_Previews: PreviewProvider {
  static var coreDataModel = DeviceModel()
  
  static var previews: some View {
    
    SettingsDetailView(device: coreDataModel.addDevice(save: false))
      .environment(\.managedObjectContext, coreDataModel.container.viewContext)
      .environmentObject(coreDataModel)
  }
}
