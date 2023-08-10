//
//  Date+extensions.swift
//  Common
//
//  Created by 김영균 on 2023/06/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

extension Date {
  public func toFormattedString(format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
  
  public func fullDateToString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 M월 d일"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(identifier: "KST")
    return dateFormatter.string(from: self)
  }
  
  public func yearMonthToString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 M월"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(identifier: "KST")
    return dateFormatter.string(from: self)
  }
  
  // 2023-07-01 타입 형태로 오래 간직할 숏스 조회
  public func toFormattedTargetDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(identifier: "KST")
    
    let formattedTargetDate = dateFormatter.string(from: self)
    return "\(formattedTargetDate)-01"
  }
  
  // 기준 월의 이전 월
  public func minusMonth() -> Date {
    guard let month = Calendar.current.date(byAdding: .month, value: -1, to: self) else {
      return Date()
    }
    return month
  }
  
  // 기준 월의 이후 월
  public func plusMonth() -> Date {
    guard let month = Calendar.current.date(byAdding: .month, value: 1, to: self) else {
      return Date()
    }
    return month
  }
  
  // 기준 월의 첫번째 날짜 출력
  public func firstDayOfMonth() -> Date {
    let components = Calendar.current.dateComponents([.year, .month], from: self)
    
    guard let day = Calendar.current.date(from: components) else {
      return Date()
    }
    return day
  }
  
  public func yearToString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    return dateFormatter.string(from: self)
  }
  
  public func monthToString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M"
    return dateFormatter.string(from: self)
  }
  
  public func yearToInt() -> Int {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    let yearString = dateFormatter.string(from: self)
    return Int(yearString)!
  }
  
  public func monthToInt() -> Int {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "M"
    let monthString = dateFormatter.string(from: self)
  
    guard let monthInt = Int(monthString) else {
      return 0
    }
    return monthInt
  }
  
  // 요일 리턴
  public func day() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEEEE"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    return dateFormatter.string(from: self)
  }
}
