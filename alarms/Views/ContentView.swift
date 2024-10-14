//
//  ContentView.swift
//  alarms
//
//  Created by colden.prime on 10/13/24.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var audioService: AudioService
  @EnvironmentObject var alarmRunner: AlarmRunner
  @EnvironmentObject var dataModel: DataModel
  
  @State var showAlert: Bool = false

  var body: some View {
    NavigationStack {
      AlarmListView()
    }
    .alert(
      "Alarm",
      isPresented: $showAlert,
      presenting: alarmRunner.activeAlarm
    ) { alarm in
      Button("Stop Alarm") {
        dismissAlarm()
      }
    } message: { alarm in
      VStack {
        Text(alarm.timestamp.formatted(date: .omitted, time: .shortened))
          .font(.headline)
        Text(alarm.sound.displayName)
          .font(.subheadline)
          .foregroundColor(.gray)
      }
    }
    .onReceive(dataModel.$alarmList) { output in
      alarmRunner.setAlarms(alarms: output)
    }
    .onReceive(alarmRunner.$activeAlarm) { newValue in
      if newValue != nil && !showAlert {
        presentAlarm(alarm: newValue!)
      } else if newValue == nil && showAlert {
        dismissAlarm()
      }
    }
  }

  func presentAlarm(alarm: Alarm) {
    showAlert = true
    audioService.playSound(sound:alarm.sound, loop: true)
  }

  func dismissAlarm() {
    showAlert = false
    audioService.reset()
    alarmRunner.clearActiveAlarm()
  }
}

#Preview() {
  ContentView()
    .environmentObject(AudioService())
    .environmentObject(AlarmRunner())
    .environmentObject(DataModel(alarmsFetchable: MockAlarmsAPI()))
}
