//
//  AddAlarmView.swift
//  alarms
//
//  Created by colden.prime on 10/13/24.
//

import SwiftUI

struct AlarmFormView: View {
  static let soundOptions: [Sound] = [.party, .brownNoise, .ocean, .whiteNoise]
  
  @State private var selectedDate = Date()
  @State private var selectedSound = soundOptions.first!

  var onCancel: () -> Void
  var onSave: (Alarm) -> Void

  init(onCancel: @escaping () -> Void, onSave: @escaping (Alarm) -> Void) {
    self.onCancel = onCancel
    self.onSave = onSave
  }

  var body: some View {
    Form {
      Section(header: Text("Alarm Settings")) {
        DatePicker(
          "Select Time",
          selection: $selectedDate,
          displayedComponents: [.hourAndMinute]
        )
        .datePickerStyle(CompactDatePickerStyle())

        Picker("Sound", selection: $selectedSound) {
          ForEach(AlarmFormView.soundOptions, id: \.self) { sound in
            Text(sound.displayName)
          }
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button("Cancel") {
          onCancel()
        }
      }
      ToolbarItem(placement: .principal) {
        Text("Create Alarm")
      }
      ToolbarItem(placement: .topBarTrailing) {
        Button("Save") {
          onSave(
            Alarm(
              timestamp: selectedDate,
              sound: selectedSound
            )
          )
        }
      }
    }
  }
}

#Preview() {
  NavigationStack {
    AlarmFormView(
      onCancel: {
        print("onCancel")
      },
      onSave: { alarm in
        print("onSave", alarm)
      }
    )
  }
}
