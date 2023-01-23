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

//      CyclesView()
//      Divider().background(Color(.blue))
      
      Spacer()
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
    HStack(spacing: 80) {
      Text("Relay Names")
      Toggle("Show empty Relay names", isOn: $device.showEmptyNames)
    }
    Spacer()
    HStack(spacing: 100) {
      
      Grid {
        GridRow {
          Text("\(device.relayArray[0].wrappedNumber).")
          TextField("", text: $device.relayArray[0].wrappedUsage)
          Toggle("Locked", isOn: $device.relayArray[0].locked)
        }
        GridRow {
          Text("\(device.relayArray[1].wrappedNumber).")
          TextField("", text: $device.relayArray[1].wrappedUsage)
          Toggle("Locked", isOn: $device.relayArray[1].locked)
        }
        GridRow {
          Text("\(device.relayArray[2].wrappedNumber).")
          TextField("", text: $device.relayArray[2].wrappedUsage)
          Toggle("Locked", isOn: $device.relayArray[2].locked)
        }
        GridRow {
          Text("\(device.relayArray[3].wrappedNumber).")
          TextField("", text: $device.relayArray[3].wrappedUsage)
          Toggle("Locked", isOn: $device.relayArray[3].locked)
        }
      }.frame(width: 250)
      Grid {
        GridRow {
          Text("\(device.relayArray[4].wrappedNumber).")
          TextField("", text: $device.relayArray[4].wrappedUsage)
          Toggle("Locked", isOn: $device.relayArray[4].locked)
        }
        GridRow {
          Text("\(device.relayArray[5].wrappedNumber).")
          TextField("", text: $device.relayArray[5].wrappedUsage)
          Toggle("Locked", isOn: $device.relayArray[5].locked)
        }
        GridRow {
          Text("\(device.relayArray[6].wrappedNumber).")
          TextField("", text: $device.relayArray[6].wrappedUsage)
          Toggle("Locked", isOn: $device.relayArray[6].locked)
        }
        GridRow {
          Text("\(device.relayArray[7].wrappedNumber).")
          TextField("", text: $device.relayArray[7].wrappedUsage)
          Toggle("Locked", isOn: $device.relayArray[7].locked)
        }
      }.frame(width: 250)
    }
  }
}

private struct CyclesView: View {
  
  var body: some View {
    VStack {
      Spacer()
      Text("Cycles View")
      Spacer()
    }
  }
}

//struct DeviceView_Previews: PreviewProvider {
//  static var previews: some View {
//    DeviceView(selectedDevice: Device() )
//  }
//}
