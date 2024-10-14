//
//  AlarmRunner.swift
//  alarms
//
//  Created by colden.prime on 10/13/24.
//

import Foundation

class AlarmRunner: ObservableObject {
  private var alarms: [Alarm] = []
  private var timers: [Timer] = []
  private var isRunning = false

  @Published private(set) var activeAlarm: Alarm?

  func setAlarms(alarms: [Alarm]) {
    self.alarms = alarms
    clearTimers()
    if isRunning {
      scheduleTimers()
    }
  }

  func clearActiveAlarm() {
    activeAlarm = nil
  }

  func enable() {
    isRunning = true
    clearTimers()
    scheduleTimers()
  }

  func disable() {
    isRunning = false
    activeAlarm = nil
    clearTimers()
  }

  private func scheduleTimers() {
    var scheduled = Set<String>()
    for alarm in alarms {
      let timeOfDay = "\(alarm.timeOfDay.hour ?? 0):\(alarm.timeOfDay.minute ?? 0)"

      // Skip scheduling multiple alarms for a single time of day
      if scheduled.contains(timeOfDay) {
        continue
      }

      // Attempt to schedule timer for alarm
      if let timer = scheduleTimer(for: alarm) {
        timers.append(timer)
        scheduled.insert(timeOfDay)
      }
    }
  }

  private func scheduleTimer(for alarm: Alarm) -> Timer? {
    let now = Date()
    let triggerDate = now.copyWithTimeOfDay(timeOfDay: alarm.timeOfDay)
    if let triggerDate = triggerDate, triggerDate > now {
      let triggerInterval = triggerDate.timeIntervalSince(now)
      return Timer.scheduledTimer(withTimeInterval: triggerInterval, repeats: false) { [weak self] _ in
        self?.triggerAlarm(alarm: alarm)
      }
    } else {
      return nil
    }
  }

  private func triggerAlarm(alarm: Alarm) {
    guard isRunning else {
      return
    }
    activeAlarm = alarm
  }

  private func clearTimers() {
    for timer in timers {
      timer.invalidate()
    }
    timers = []
  }
}
