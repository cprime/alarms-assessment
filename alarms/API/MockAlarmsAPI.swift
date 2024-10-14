//
//  MockAlarmsAPI.swift
//  alarms
//
//  Created by colden.prime on 10/13/24.
//

import Foundation

struct MockAlarmsAPI: AlarmsFetchable {
  func fetchAlarms(completion: @escaping (Result<[Alarm], APIError>) -> Void) {
    let formatter = ISO8601DateFormatter()
    Task { @MainActor in
      completion(
        .success(
          [
            Alarm(
              timestamp: formatter.date(from: "2025-01-01T00:00:00+0000")!,
              sound: .party,
              isSynced: true
            ),
            Alarm(
              timestamp: formatter.date(from: "2026-07-11T16:04:00+0000")!,
              sound: .brownNoise,
              isSynced: true
            ),
            Alarm(
              timestamp: formatter.date(from: "2024-09-15T16:04:00+0000")!,
              sound: .ocean
            ),
            Alarm(
              timestamp: formatter.date(from: "2026-07-11T16:04:00+0000")!,
              sound: .whiteNoise
            ),
          ]
        )
      )
    }
  }
}
