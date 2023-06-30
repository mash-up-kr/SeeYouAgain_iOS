//
//  HotKeywordDTO.swift
//  Models
//
//  Created by lina on 2023/06/18.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct HotKeywordDTO: Decodable, Equatable {
  public let createdAt: String
  public let ranking: [String]
  
  public var standardTimeString: String {
    if let date = DateFormatter.hotKeywordDateFormatter.date(from: createdAt) {
      let calendar = Calendar.current
      let year = calendar.component(.year, from: date)
      let month = calendar.component(.month, from: date)
      let day = calendar.component(.day, from: date)
      let hour = calendar.component(.hour, from: date)
      
      return "\(year)년 \(month)월 \(day)일 \(hour):01 ~ \(hour + 1):00 기준"
    }
    return ""
  }
  
  public init(createdAt: String, ranking: [String]) {
    self.createdAt = createdAt
    self.ranking = ranking
  }
}

// extension에 model이 접근을 못하고, 어짜피 이 모델만 사용해서 여기에 별도로 extension함
private extension DateFormatter {
  static let hotKeywordDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return dateFormatter
  }()
}
