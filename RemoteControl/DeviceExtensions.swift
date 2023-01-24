//
//  DeviceExtensions.swift
//  RemoteControl
//
//  Created by Douglas Adams on 1/22/23.
//

import Foundation

extension Device {
  // eliminate the "optional" problem
  // entries not needed here for Bool attributes
  public var wrappedId: UUID { id ?? UUID() }
  public var wrappedIpAddress: String{
    get { ipAddress ?? "" }
    set { ipAddress = newValue }}
  public var wrappedName: String {
    get { name ?? "New" }
    set { name = newValue }}
  public var wrappedPassword: String {
    get { password ?? "" }
    set { password = newValue }}
  public var wrappedTitle: String {
    get { title ?? "" }
    set { title = newValue }}
  public var wrappedUser: String {
    get { user ?? "" }
    set { user = newValue }}
}

extension Device {
  // convert from NSSet <--> Array
  // ----- RELAYS -----
  public var relayArray: [Relay] {
    get {
      let set = relays as? Set<Relay> ?? []
      return set.sorted {
        $0.number < $1.number
      }
    }
    set {
      relays = NSSet(array: newValue)
    }
  }
  // ----- ON STEPS -----
  public var onStepsArray: [OnStep] {
    get {
      let set = onSteps as? Set<OnStep> ?? []
      return set.sorted {
        $0.relayNumber < $1.relayNumber
      }
    }
    set {
      onSteps = NSSet(array: newValue)
    }
  }
  // ----- OFF STEPS -----
  public var offStepsArray: [OffStep] {
    get {
      let set = offSteps as? Set<OffStep> ?? []
      return set.sorted {
        $0.relayNumber < $1.relayNumber
      }
    }
    set {
      offSteps = NSSet(array: newValue)
    }
  }
}

extension Relay {
  // eliminate the "optional" problem
  // entries not needed here for Bool attributes
  public var wrappedUsage: String{
    get { usage ?? "" }
    set { usage = newValue }}
  public var wrappedNumber: Int{
    get { Int(number) }
    set { number = Int16(newValue) }}
}

extension OnStep {
  // eliminate the "optional" problem
  // entries not needed here for Bool attributes
  public var wrappedRelayNumber: Int {
    get { Int(relayNumber) }
    set { relayNumber = Int16(newValue) }}
  public var wrappedDelay: Int {
    get { Int(delay) }
    set { delay = Int16(newValue) }}
}

extension OffStep {
  // eliminate the "optional" problem
  // entries not needed here for Bool attributes
  public var wrappedRelayNumber: Int {
    get { Int(relayNumber) }
    set { relayNumber = Int16(newValue) }}
  public var wrappedDelay: Int {
    get { Int(delay) }
    set { delay = Int16(newValue) }}
}

