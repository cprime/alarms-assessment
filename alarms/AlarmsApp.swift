//
//  alarmsApp.swift
//  alarms
//
//  Created by colden.prime on 10/13/24.
//

import SwiftUI

@main
struct AlarmsApp: App {
  let audioService = AudioService()
  let alarmRunner = AlarmRunner()
  let dataModel = DataModel(alarmsFetchable: AlarmsAPI())

  @Environment(\.scenePhase) var scenePhase

  var body: some Scene {

    WindowGroup {
      ContentView()
    }
    .onChange(of: scenePhase) { _, newPhase in
      if newPhase == .active {
        alarmRunner.enable()
      } else {
        alarmRunner.disable()
        audioService.reset()
      }
    }
    .environmentObject(audioService)
    .environmentObject(alarmRunner)
    .environmentObject(dataModel)
  }
}
