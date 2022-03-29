//
//  Functions.swift
//  BookingApp
//
//  Created by Swift on 24/3/22.
//

import Foundation

// helper functions
func firstDayOfWeek() -> Date {
    var c = Calendar(identifier: .iso8601)
    c.timeZone = TimeZone(secondsFromGMT: 0)!
    return c.date(from: c.dateComponents([.weekOfYear, .yearForWeekOfYear], from: Date()))!
}

func lastDayOfWeek() -> Date {
    var c = Calendar(identifier: .iso8601)
    c.timeZone = TimeZone(secondsFromGMT: 0)!
    let firstDay = c.date(from: c.dateComponents([.weekOfYear, .yearForWeekOfYear], from: Date()))!
    let lastDay = Calendar.current.date(byAdding: .day, value: 6, to: firstDay)!
    
    return lastDay
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}
