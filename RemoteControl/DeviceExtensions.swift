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
  // ----- LOCKS -----
  public var locksArray: [Lock] {
    get {
      let set = locks as? Set<Lock> ?? []
      return set.sorted {
        $0.lockNumber < $1.lockNumber
      }
    }
    set {
      locks = NSSet(array: newValue)
    }
  }
  // ----- ON STEPS -----
  public var onStepsArray: [OnStep] {
    get {
      let set = onSteps as? Set<OnStep> ?? []
      return set.sorted {
        $0.stepNumber < $1.stepNumber
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
        $0.stepNumber < $1.stepNumber
      }
    }
    set {
      offSteps = NSSet(array: newValue)
    }
  }
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
  public var wrappedStepNumber: Int {
    get { Int(stepNumber) }
    set { stepNumber = Int16(newValue) }}
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
  public var wrappedStepNumber: Int {
    get { Int(stepNumber) }
    set { stepNumber = Int16(newValue) }}
}

