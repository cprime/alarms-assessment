//
//  DataModel.swift
//  alarms
//
//  Created by colden.prime on 10/13/24.
//

import Combine
import Foundation

protocol DataModelInterface: ObservableObject {
  var alarmList: [Alarm] { get }
  var isFetching: Bool { get }

  func fetchAlarms()
  func addAlarm(alarm: Alarm)
}

class DataModel {
  @Published var alarmList: [Alarm]
  @Published var isFetching: Bool

  private let alarmsFetcher: AlarmsFetchable
  private var serverAlarms: [Alarm] = []
  private var localAlarms: [Alarm] = []
  private var disposables = Set<AnyCancellable>()

  required init(alarmsFetchable: AlarmsFetchable) {
    self.alarmsFetcher = alarmsFetchable
    self.alarmList = [Alarm]()
    self.isFetching = false
  }

  private func refreshAlarmList() {
    var result = serverAlarms + localAlarms
    result.sort { a, b in
      let aTimeOfDay = a.timeOfDay
      let bTimeOfDay = b.timeOfDay
      if aTimeOfDay.hour == b.timeOfDay.hour {
        return (aTimeOfDay.minute ?? 0) < (bTimeOfDay.minute ?? 0)
      } else {
        return (aTimeOfDay.hour ?? 0) < (bTimeOfDay.hour ?? 0)
      }
    }
    alarmList = result
  }
}

//MARK: - AlarmListViewModelInterface Extension

extension DataModel: DataModelInterface {
  func fetchAlarms() {
    isFetching = true
    alarmsFetcher.fetchAlarms { [weak self] result in
      Task{ @MainActor in
        self?.isFetching = false
        if let alarms = try? result.get() {
          self?.serverAlarms = alarms
          self?.refreshAlarmList()
        }
      }
    }
  }

  func addAlarm(alarm: Alarm) {
    localAlarms.append(alarm)
    refreshAlarmList()
  }
}
