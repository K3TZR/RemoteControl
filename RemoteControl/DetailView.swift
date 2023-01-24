//
//  DeviceView.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/21/23.
//

import SwiftUI

struct DetailView: View {
  @ObservedObject var device: Device
  
  @EnvironmentObject var dataController : DataController

  var body: some View {
    VStack {
      DeviceParamsView(device: device)
      Divider().background(Color(.blue))
      
      RelaysView(device: device)
      Divider().background(Color(.blue))

      CyclesView(device: device)
      Divider().background(Color(.blue))
      
      Button("Save Changes") { dataController.save() }.disabled(!device.hasChanges)
    }
    .onDisappear { print("DetailView onDisappear") }
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
  @ObservedObject var device: Device

  var body: some View {
    HStack(spacing: 100) {

      Grid (verticalSpacing: 5) {
        GridRow {
          Text("#")
          Text("Usage")
          Text("Lock")
        }
        ForEach($device.relayArray, id: \.self) { $relay in
          if relay.wrappedNumber % 2 != 0 {
            GridRow {
              Text("\(relay.wrappedNumber).")
              TextField("", text: $relay.wrappedUsage)
              Toggle("", isOn: $relay.locked)
            }
          }
        }
      }.frame(width: 250)

      Grid (verticalSpacing: 5) {
        GridRow {
          Text("#")
          Text("Usage")
          Text("Lock")
        }
        ForEach($device.relayArray, id: \.self) { $relay in
          if relay.wrappedNumber % 2 == 0 {
            GridRow {
              Text("\(relay.wrappedNumber).")
              TextField("", text: $relay.wrappedUsage)
              Toggle("", isOn: $relay.locked)
            }
          }
        }
      }.frame(width: 250)
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

struct DeviceView_Previews: PreviewProvider {
  static var dataController = DataController()
  
  static var previews: some View {
    
    DetailView(device: dataController.addDevice(save: false))
      .environment(\.managedObjectContext, dataController.container.viewContext)
      .environmentObject(dataController)
  }
}
