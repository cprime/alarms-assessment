//
//  AlarmsAPI.swift
//  alarms
//
//  Created by colden.prime on 10/13/24.
//

import Combine
import Foundation

struct AlarmListPayload: Codable {
  var alarms: [Alarm]
}

enum APIError: Error {
  case network(message: String)
  case parsing(message: String)
  case other(message: String)
}

protocol AlarmsFetchable {
  func fetchAlarms(completion: @escaping (Result<[Alarm], APIError>) -> Void)
}

class AlarmsAPI {
  // TODO: Add API back in
  private let url = URL(string: "")!
  private let session: URLSession
  private let decoder = JSONDecoder()

  init(session: URLSession = .shared) {
    self.session = session
    decoder.dateDecodingStrategy = .iso8601
  }
}

extension AlarmsAPI: AlarmsFetchable {
  func fetchAlarms(completion: @escaping (Result<[Alarm], APIError>) -> Void) {
    let decoder = self.decoder
    let task = session.dataTask(with: URLRequest(url: url)) { data, response, error in
      if let data = data {
        do {
          let payload = try decoder.decode(AlarmListPayload.self, from: data)
          let alarms = payload.alarms.map { alarm in
            var copy = alarm
            copy.isSynced = true
            return copy
          }
          completion(.success(alarms))
        } catch let parsingError {
          debugPrint(parsingError)
          completion(.failure(.parsing(message: parsingError.localizedDescription)))
        }
      } else {
        completion(.failure(.network(message: error?.localizedDescription ?? "Unknown")))
      }
    }
    task.resume()
  }
}
