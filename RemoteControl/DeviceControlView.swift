//
//  DeviceControlView.swift
//  DliProSwitch
//
//  Created by Douglas Adams on 1/11/23.
//

import AVFoundation
import SwiftUI

struct DeviceControlView: View {
  @EnvironmentObject var deviceModel : DeviceModel
  @EnvironmentObject var relaysModel: RelaysModel

  @AppStorage("deviceIndex") var deviceIndex: Int = -1
  
  @FetchRequest(sortDescriptors: [ SortDescriptor(\.name),]) var devices: FetchedResults<Device>
  
  var body: some View {
    if devices.count == 0  {
      // NO Devices
      VStack {
        Spacer()
        Text("Add a Device")
        Spacer()
      }
      .frame(width: 275, height:450)
      .padding()
      
      .onAppear {
        // No Devices
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
      }
      
    } else if deviceIndex == -1 {
      // NO Selected Device
      VStack {
        Spacer()
        Text("Select a device").font(.title)
        Picker("Device", selection: $deviceIndex) {
          Text("None").tag(-1)
          ForEach(Array(devices.enumerated()), id: \.offset) { offset, device in
            Text(String(device.wrappedName)).tag(offset as Int)
          }
        }
        .labelsHidden()
        .frame(width: 150)
        Spacer()
      }
      .frame(width: 275, height:450)
      .padding()

      
    } else {
      // A Selected Device
      let device = devices[deviceIndex]
      
      VStack {
        Text(device.wrappedTitle).font(.title)
        Divider().background(Color(.blue))
        Spacer()
        
        RelaysView(device: device)
        BottomButtonsView()
      }
      .onChange(of: deviceIndex) { newValue in
        if newValue != -1 {
          // A valid Device was selected
          relaysModel.relaysSync(devices[newValue])
        }
      }
      .onAppear {
        if devices.count == 0 {
          // No Devices
          NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else if deviceIndex != -1 {
          // A Device exists
          relaysModel.relaysSync(devices[deviceIndex])
        }
      }
      .toolbar {
        ToolbarItem {
          Picker("Device", selection: $deviceIndex) {
            Text("None").tag(-1)
            ForEach(Array(devices.enumerated()), id: \.offset) { offset, device in
              Text(String(device.wrappedName)).tag(offset as Int)
            }
          }
          .frame(width: 150)
        }
      }
      .frame(width: 275, height:450)
      .padding()
    }
  }
}

//
//    .sheet(isPresented: $model.showSheet) {
//      FailureView(model: model)
//    }
//  }
//}

private struct RelaysView: View {
  @ObservedObject var device: Device
  
  @EnvironmentObject var deviceModel : DeviceModel
  @EnvironmentObject var relaysModel: RelaysModel

  var body: some View {
    Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
      ForEach(relaysModel.relays, id: \.id) { relay in
        if device.showEmptyNames || !relay.name.isEmpty {
          GridRow {
            Text(relay.name).font(.title2).frame(width: 200, alignment: .leading)
            Image(systemName: relay.isLocked ? "lock.slash.fill" : device.locksArray[relay.number - 1].value ? "lock" : "power")
              .font(.system(size: 28, weight: .bold))
              .foregroundColor(relay.isOn ? .green : .red)
              .onTapGesture {
                relaysModel.relayToggleState(relay.number)
              }.disabled( relaysModel.inProcess || relay.isLocked || device.locksArray[relay.number - 1].value)
            
              .contextMenu {
                Button(device.locksArray[relay.number - 1].value ? "Unlock" : "Lock") {
                  deviceModel.toggleLock(device, relay.number)
                }
              }.disabled( relaysModel.inProcess || relay.isLocked )
          }
        }
      }
    }
  }
}

private struct BottomButtonsView: View {
  @EnvironmentObject var relaysModel: RelaysModel

  var body: some View {
    Spacer()
    Divider().background(Color(.blue))
    HStack {
      Button(action: { relaysModel.relaysAllState(false) }){ Text("All OFF") }
      Spacer()
      Text("Cycle")
      Button("ON") { relaysModel.relaysCycle(on: true) }
      Button("OFF") { relaysModel.relaysCycle(on: false) }
    }.disabled(relaysModel.inProcess)
  }
}

//struct Dashboardiew_Previews: PreviewProvider {
//  static var previews: some View {
//    DashboardDetailView(device: Device())
//  }
//}

//struct FailureView: View {
//  let model: DataModel
//
//  @Environment(\.dismiss) private var dismiss
//
//  var body: some View {
//
//    VStack {
//      if model.deviceIndex == -1 {
//        Text("No Device Selected").font(.title).foregroundColor(.red)
//        Divider().background(Color(.blue))
//        Spacer()
//        Text("Select or Add a Device").font(.title2)
//        Spacer()
//
//      } else if model.thrownError != nil {
//        Text("An error occurred").font(.title).foregroundColor(.red)
//        Divider().background(Color(.blue))
//        Spacer()
//        if let theError = model.thrownError as? ApiError {
//          switch theError {
//          case .getRequestFailure:  Text("Get request failure").font(.title2)
//          case .jsonDecodeFailure:  Text("Json decode failure").font(.title2)
//          case .putRequestFailure:  Text("Put request failure").font(.title2)
//          case .queryFailure:       Text("Device query failure").font(.title2)
//          }
//        } else {
//          Text("Unknown error").font(.title2)
//        }
//        Spacer()
//        Divider().background(Color(.blue))
//        Spacer()
//        Text("Check your device & settings").font(.title2)
//
//      } else {
//        Text(model.devices[model.deviceIndex].name).font(.title)
//        Text("Unable to reach the Device").font(.title2).foregroundColor(.red)
//        Divider().background(Color(.blue))
////        Spacer()
//        Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
//          GridRow() {
//            Text("at IP Address")
//            Text(model.devices[model.deviceIndex].ipAddress)
//          }
//        }.font(.title2)
//        Divider().background(Color(.blue))
//        Spacer()
//        Text("Update your settings").font(.title2)
//      }
//
//      Divider().background(Color(.blue))
//      Button("OK") { dismiss(); NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil) }.keyboardShortcut(.defaultAction)
//    }
//
//    .frame(width: 275, height: 200)
//    .padding()
//  }
//}
