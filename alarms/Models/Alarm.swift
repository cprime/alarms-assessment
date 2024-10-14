//
//  Alarm.swift
//  alarms
//
//  Created by colden.prime on 10/13/24.
//

import Foundation

enum Sound: String, Codable {
  case party = "party"
  case brownNoise = "brown-noise"
  case ocean = "ocean"
  case whiteNoise = "white-noise"

  var displayName: String {
    switch self {
    case .party: "Party"
    case .brownNoise: "Brown Noise"
    case .ocean: "Ocean"
    case .whiteNoise: "White Noise"
    }
  }
}

struct Alarm: Identifiable, Codable, Equatable {
  var id = UUID()
  var timestamp: Date
  var sound: Sound
  var isSynced: Bool

  var timeOfDay: DateComponents {
    return Calendar(identifier: .gregorian).dateComponents([.hour, .minute], from: timestamp)
  }

  init(timestamp: Date, sound: Sound, isSynced: Bool = false) {
    self.timestamp = timestamp
    self.sound = sound
    self.isSynced = isSynced
  }

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
    self.timestamp = try container.decode(Date.self, forKey: .timestamp)
    self.sound = (try? container.decode(Sound.self, forKey: .sound)) ?? .party
    self.isSynced = (try? container.decode(Bool.self, forKey: .isSynced)) ?? false
  }
}
