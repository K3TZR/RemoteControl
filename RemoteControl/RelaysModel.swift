//
//  DataModel.swift
//
//
//  Created by Douglas Adams on 4/13/22.
//

import Foundation
import SwiftUI

enum ApiError: Error {
  case getRequestFailure
  case jsonDecodeFailure
  case putRequestFailure
  case queryFailure
}

public struct Relay: Codable, Equatable, Identifiable {
  
  public init(
    name: String = "",
    isOn: Bool = false,
    isLocked: Bool = false
  ) {
    self.name = name
    self.isOn = isOn
    self.isLocked = isLocked
  }
  public var id = UUID()
  public var number = 1
  public var name: String
  public var isOn: Bool
  public var isLocked: Bool
  
  public enum CodingKeys: String, CodingKey {
    case name
    case isOn = "state"
    case isLocked = "locked"
  }
}

public struct CycleStep: Identifiable, Codable {
  internal init(id: UUID = UUID(), index: Int, enable: Bool, value: Bool, delay: Int) {
    self.id = id
    self.index = index
    self.enable = enable
    self.value = value
    self.delay = delay
  }
  
  public var id: UUID
  var index: Int
  var enable: Bool
  var value: Bool
  var delay: Int
}

@MainActor
class RelaysModel: ObservableObject {
  @Published var relays = [
    Relay(),
    Relay(),
    Relay(),
    Relay(),
    Relay(),
    Relay(),
    Relay(),
    Relay(),
  ]
  @Published var inProcess = false
  @Published var selectedDevice: Device?
  @Published var showSheet = false
  
  var previousRelays: [Relay]?
  var thrownError: Error? = nil
  
  // ----------------------------------------------------------------------------
  // MARK: - Relay methods
  
  func relaySetName(_ name: String, _ index: Int) {
    if selectedDevice != nil {
      // prevent re-entrancy
      guard !inProcess else { return }
      inProcess = true
      defer { inProcess = false }
      
      if !relays[index].isLocked {
        Task {
          await setRemoteProperty(.name, at: index, to: name)
        }
      }
    }
  }
  
  func relayToggleState(_ index: Int) {
    
    if selectedDevice != nil {
      guard !inProcess else { return }
      inProcess = true
      defer { inProcess = false }
      guard (1...8).contains(index) else { return }
      
      // tell the box to change the relay's state
      let newValue = relays[index-1].isOn ? "false" : "true"
      Task {
        await setRemoteProperty(.isOn, at: index-1, to: newValue)
      }
      // change it locally
      relays[index-1].isOn.toggle()
    }
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - Relays methods
  
  func relaysAllState(_ value: Bool) {
    if selectedDevice != nil {
      // prevent re-entrancy
      guard !inProcess else { return }
      inProcess = true
      defer { inProcess = false }
      
      Task {
        await setRemoteProperty(.isOn, at: -1, to: value ? "true" : "false")
      }
      for i in 0...7 {
        if !relays[i].isLocked { relays[i].isOn = value }
      }
    }
  }
  
  func relaysCycle(on: Bool) {
    if let device = selectedDevice {
      // prevent re-entrancy
      guard !inProcess else { return }
      
      Task {
        setInProcess(true)
        if on {
          for entry in device.onStepsArray {
            if entry.enabled && !relays[entry.wrappedRelayNumber - 1].isLocked {
              await setRemoteProperty(.isOn, at: entry.wrappedRelayNumber - 1, to: entry.newValue ? "true" : "false")
              relays[entry.wrappedRelayNumber - 1].isOn = entry.newValue
              try await Task.sleep(for: .seconds(entry.delay))
            }
          }
        } else {
          for entry in device.offStepsArray {
            if entry.enabled && !relays[entry.wrappedRelayNumber - 1].isLocked {
              await setRemoteProperty(.isOn, at: entry.wrappedRelayNumber - 1, to: entry.newValue ? "true" : "false")
              relays[entry.wrappedRelayNumber - 1].isOn = entry.newValue
              try await Task.sleep(for: .seconds(entry.delay))
            }
          }
        }
        setInProcess(false)
      }
    }
  }
  
  func relaysUpdate(_ device: Device?) {
    selectedDevice = device
    if selectedDevice != nil {
      Task {
        for i in 0...7 {
          if let previous = previousRelays {
            // only send changed names
            if relays[i].name != previous[i].name {
              
              print("Name changed for Relay \(i+1): from \(previous[i].name) to \(relays[i].name) ")
              
              let name = relays[i].name
              await setRemoteProperty(.name, at: i, to: name)
              try! await Task.sleep(for: .milliseconds(30))
            }
            
          } else {
            // send all names
            
            print("ALL names changed")
            
            let name = relays[i].name
            await setRemoteProperty(.name, at: i, to: name)
            try! await Task.sleep(for: .milliseconds(30))
          }
        }
      }
    }
  }
  
  func relaysSync(_ device: Device?) {
    selectedDevice = device
    if selectedDevice != nil {
      Task {
        do {
          try await relaysSynchronize()
        } catch {
          showSheet = true
        }
      }
    }
  }
  
  private func relaysSynchronize() async throws {
    if let device = selectedDevice {
      // prevent re-entrancy
      guard !inProcess else { return }
      inProcess = true
      defer { inProcess = false }
      
      // get device characteristics
      let user = device.wrappedUser
      let password = device.wrappedPassword
      let ipAddress = device.wrappedIpAddress
      
      previousRelays = relays
      
      // interrogate the device
      do {
        relays = try JSONDecoder().decode( [Relay].self, from: (await getRequest(url: URL(string: "https://\(ipAddress)/restapi/relay/outlets/")!,
                                                                                 user: user,
                                                                                 password: password)))
        // init the relay numbers
        for i in 0...7 {
          relays[i].number = i+1
        }
        
      } catch {
//        fatalError("Failed to Sync Relays")
//        thrownError = error as? ApiError
//        showSheet = true
      }
    }
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - Misc methods
  
  private func setInProcess(_ state: Bool) {
    inProcess = state
  }
  
  private func setRemoteProperty(_ property: Relay.CodingKeys, at index: Int, to value: String) async {
    if let device = selectedDevice {
      var indexString = ""
      
      if index == -1 {
        indexString = "all;"
      } else if index >= 0 && index < relays.count {
        indexString = String(index)
      } else {
        return
      }
      let user = device.wrappedUser
      let password = device.wrappedPassword
      let ipAddress = device.wrappedIpAddress
      let url = URL(string: "https://\(ipAddress)/restapi/relay/outlets/\(indexString)/\(property.rawValue)/")!
      do {
        try await putRequest(Data(value.utf8), url: url, user: user, password: password)
      } catch {
        thrownError = error
        showSheet = true
      }
    }
  }
  
  // ----------------------------------------------------------------------------
  // MARK: - URL methods
  
  func getRequest(url: URL, user: String, password: String) async throws -> Data {
    let successRange = 200...299
    let headers = [
      "Connection": "close",
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-CSRF": "x"
    ]
    var request = URLRequest(url: url)
    request.setBasicAuth(user, password)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard successRange.contains((response as! HTTPURLResponse).statusCode) else {
      throw ApiError.getRequestFailure
    }
    return data
  }
  
  func putRequest(_ data: Data, url: URL, user: String, password: String, jsonContent: Bool = false) async throws {
    let successRange = 200...299
    var headers: [String:String] = [:]
    
    if jsonContent {
      headers = [
        "Connection": "close",
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF": "x"
      ]
    } else {
      headers = [
        "Connection": "close",
        "ContentType":"text/plain",
        "X-CSRF": "x"
      ]
    }
    
    var request = URLRequest(url: url)
    request.setBasicAuth(user, password)
    request.allHTTPHeaderFields = headers
    request.httpMethod = jsonContent ? "POST" : "PUT"
    request.httpBody = data
    
    let (_, response) = try await URLSession.shared.data(for: request)
    guard successRange.contains((response as! HTTPURLResponse).statusCode) else {
      throw ApiError.putRequestFailure
    }
  }
}

// ----------------------------------------------------------------------------
// MARK: - URL extension

extension URLRequest {
  mutating func setBasicAuth(_ user: String, _ pwd: String) {
    let encodedAuthInfo = String(format: "%@:%@", user, pwd)
      .data(using: String.Encoding.utf8)!
      .base64EncodedString()
    addValue("Basic \(encodedAuthInfo)", forHTTPHeaderField: "Authorization")
  }
}
