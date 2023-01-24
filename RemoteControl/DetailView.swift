//
//  DeviceView.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/21/23.
//

import SwiftUI

struct DetailView: View {
  @ObservedObject var device: Device
  
  @Environment(\.managedObjectContext) var moc
  
  var body: some View {
    VStack {
      DeviceParamsView(device: device)
      Divider().background(Color(.blue))
      
      RelaysView(device: device)
      Divider().background(Color(.blue))

      CyclesView(device: device)
      Divider().background(Color(.blue))
      
      Button("Save") { try? moc.save() }
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
          if (1...4).contains(relay.wrappedNumber) {
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
          if (5...8).contains(relay.wrappedNumber) {
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
  
  var body: some View {
    HStack(spacing: 250) {
      Text("Cycle ON")
      Text("Cycle OFF")
    }
    HStack(spacing: 100) {
      
      Grid (verticalSpacing: 5) {
        GridRow {
          Text("#")
          Text("Enabled")
          Text("Value")
          Text("Delay")
        }
        ForEach($device.onStepsArray, id: \.self) { $step in
          GridRow {
            Text("\(step.wrappedRelayNumber).")
            Toggle("", isOn: $step.enabled)
            Toggle("", isOn: $step.newValue)
            TextField("", value: $step.wrappedDelay, format: .number)
              .multilineTextAlignment(.trailing)
              .frame(width: 75)
          }
        }
      }.frame(width: 250)
      
      Grid (verticalSpacing: 5) {
        GridRow {
          Text("#")
          Text("Enabled")
          Text("Value")
          Text("Delay")
        }
        ForEach($device.offStepsArray, id: \.self) { $step in
          GridRow {
            Text("\(step.wrappedRelayNumber).")
            Toggle("", isOn: $step.enabled)
            Toggle("", isOn: $step.newValue)
            TextField("", value: $step.wrappedDelay, format: .number)
              .multilineTextAlignment(.trailing)
              .frame(width: 75)
          }
        }
      }.frame(width: 250)
    }
  }
}

struct DeviceView_Previews: PreviewProvider {
  static var dataController = DataController.preview
  
  static var previews: some View {
      let device = Device(context: dataController.container.viewContext)
      
      return DetailView(device: device)
          .environment(\.managedObjectContext, dataController.container.viewContext)
          .environmentObject(dataController)
  }
}
