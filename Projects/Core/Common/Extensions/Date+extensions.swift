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
    Calendar.current.date(byAdding: .month, value: -1, to: self)!
    
  }
  
  // 기준 월의 이후 월
  public func plusMonth() -> Date {
    Calendar.current.date(byAdding: .month, value: 1, to: self)!
  }
  
  // 기준 월의 첫번째 날짜 출력
  public func firstDayOfMonth() -> Date {
    let components = Calendar.current.dateComponents([.year, .month], from: self)
    return Calendar.current.date(from: components)!
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
}
