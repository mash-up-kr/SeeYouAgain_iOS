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
    var standardDate = Date()
    if let date = DateFormatter.hotKeywordDateFormatter1.date(from: createdAt) {
      standardDate = date
    } else if let date = DateFormatter.hotKeywordDateFormatter2.date(from: createdAt) {
      standardDate = date
    } else {
      return ""
    }
    
    let calendar = Calendar.current
    let year = calendar.component(.year, from: standardDate)
    let month = calendar.component(.month, from: standardDate)
    let day = calendar.component(.day, from: standardDate)
    let hour = calendar.component(.hour, from: standardDate)
    
    return "\(year)년 \(month)월 \(day)일 \(hour):01 ~ \(hour + 1):00 기준"
  }
  
  public init(createdAt: String, ranking: [String]) {
    self.createdAt = createdAt
    self.ranking = ranking
  }
}

// extension에 model이 접근을 못하고, 어짜피 이 모델만 사용해서 여기에 별도로 extension함
// 서버에서 날짜 포맷을 계속 변경하고 있어서 임의로 2개 다 사용. 서버 안정화 이후 하나만 남길 예정
private extension DateFormatter {
  static let hotKeywordDateFormatter1: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return dateFormatter
  }()
  
  static let hotKeywordDateFormatter2: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    return dateFormatter
  }()
}
