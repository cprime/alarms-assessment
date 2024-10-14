//
//  AudioService.swift
//  alarms
//
//  Created by colden.prime on 10/13/24.
//

import AVFoundation

extension Sound {
  var resourcePath: String {
    switch self {
    case .party: "party.m4a"
    case .brownNoise: "brown-noise.m4a"
    case .ocean: "ocean.m4a"
    case .whiteNoise: "white-noise.m4a"
    }
  }
}

class AudioService: ObservableObject {
  var audioPlayer: AVAudioPlayer?

  func playSound(sound: Sound, loop: Bool = false) {
    reset()

    if let path = Bundle.main.path(forResource: sound.resourcePath, ofType: nil) {
      do {
        try AVAudioSession.sharedInstance().setCategory(.playback)
        try AVAudioSession.sharedInstance().setActive(true)

        let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        player.prepareToPlay()
        player.numberOfLoops = loop ? -1 : 0
        player.play()

        audioPlayer = player
      } catch let error {
        debugPrint(error)
      }
    }
  }

  func reset() {
    audioPlayer?.stop()
    audioPlayer = nil
  }
}
