//
//  ConsecutiveDay.swift
//  Models
//
//  Created by 안상희 on 2023/08/06.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public enum ConsecutiveDay: Int, CustomStringConvertible {
  case one = 1
  case two = 2
  case three = 3
  case four = 4
  case five = 5
  case six = 6
}

public extension ConsecutiveDay {
  init?(days: Int) {
    self.init(rawValue: days)
  }
  
  var description: String {
    switch self {
    case .one:
      return "하루"
      
    case .two:
      return "이틀"
      
    case .three:
      return "3일"
      
    case .four:
      return "4일"
      
    case .five:
      return "5일"
      
    case .six:
      return "6일"
    }
  }
}
