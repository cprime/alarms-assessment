//
//  AlarmsView.swift
//  alarms
//
//  Created by colden.prime on 10/13/24.
//

import SwiftUI

struct AlarmListView: View {
  @EnvironmentObject private var dataModel: DataModel
  
  @State private var isShowingAddForm = false

  var body: some View {
    Group {
      if dataModel.isFetching {
        VStack {
          ProgressView()
            .padding()
          Text("Loading Alarms...")
            .padding()
        }
        .padding()
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(Color.white)
            .shadow(
              color: Color.black.opacity(0.2),
              radius: 10, x: 0, y: 5
            )
        )
      } else {
        List {
          ForEach(dataModel.alarmList) { alarm in
            HStack {
              VStack(alignment: .leading) {
                Text(alarm.timestamp.formatted(date: .omitted, time: .shortened))
                  .font(.headline)
                Text(alarm.sound.displayName)
                  .font(.subheadline)
                  .foregroundColor(.gray)
              }
              Spacer()
              if alarm.isSynced {
                Image(systemName: "cloud")
              }
            }
            .padding(.vertical, 8)
          }
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text("Alarms")
      }
      ToolbarItem(placement: .topBarTrailing) {
        Button("Add") {
          isShowingAddForm = true
        }
      }
    }
    .sheet(
      isPresented: $isShowingAddForm,
      content: {
        NavigationStack {
          AlarmFormView(
            onCancel: {
              isShowingAddForm = false
            },
            onSave: { alarm in
              isShowingAddForm = false
              dataModel.addAlarm(alarm: alarm)
            }
          )
        }
      }
    )
    .onAppear {
      dataModel.fetchAlarms()
    }
  }
}

#Preview() {
  NavigationStack {
    AlarmListView()
      .environmentObject(DataModel(alarmsFetchable: MockAlarmsAPI()))
      .environmentObject(AudioService())
  }
}
