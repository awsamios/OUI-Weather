//
//  DateFormat.swift
//  OUI-Weather
//
//  Created by Samira on 16/07/2018.
//  Copyright © 2018 Bands. All rights reserved.
//

import Foundation

extension TimeZone {
  static var defaultTimezone: TimeZone {
    return TimeZone(abbreviation: "UTC")!
  }
}

// MARK: - Formatter

extension DateFormatter {
  /// The default date formatter.
  static var `default`: DateFormatter {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.defaultTimezone
    formatter.locale = Locale(identifier: "fr_FR")
    return formatter
  }
  
  
  static var timezoneDateFormatter: DateFormatter? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone.defaultTimezone
    dateFormatter.locale = Locale(identifier: "fr_FR")
    return dateFormatter
  }
  
  
}

extension String {
  /// Get the ISO date from the current string.
  var isoDate: Date? {
    let formatter = DateFormatter.timezoneDateFormatter
    return formatter?.date(from: self)
  }
  
  /// Get the associated date from the current string represented timestamp.
  var timestampDate: Date? {
    guard let timestamp = Double(self) else {
      return nil
    }
    
    return Date(timeIntervalSince1970: timestamp)
  }
}


extension Date {
  /// Get the date from a date formatted string.
  /// Format: yyyy-MM-dd
  /// Example: `2018-07-12`
  var shortDate: Date? {
    let formatter = DateFormatter.default
    formatter.dateFormat = "yyyy-MM-dd"
    let shortDateString = formatter.string(from: self)
    return formatter.date(from: shortDateString)
  }
  
  func dayOfWeek() -> String? {
    let dateFormatter = DateFormatter.default
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: self).capitalized
  }
}
