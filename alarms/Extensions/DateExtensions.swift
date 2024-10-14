//
//  DateExtensions.swift
//  alarms
//
//  Created by colden.prime on 10/13/24.
//

import Foundation

extension Date {
  func copyWithTimeOfDay(timeOfDay: DateComponents) -> Date? {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day, .timeZone], from: self)
    components.hour = timeOfDay.hour
    components.minute = timeOfDay.minute
    return calendar.date(from: components)
  }
}
