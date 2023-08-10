//
//  ConsecutiveDay.swift
//  Models
//
//  Created by 안상희 on 2023/08/06.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public enum ConsecutiveDay: Int, CustomStringConvertible {
  case zero = 0
  case one = 1
  case two = 2
  case three = 3
  case four = 4
  case five = 5
  case six = 6
  case seven = 7
  case minusOne = -1
  case minusTwo = -2
  case minusThree = -3
  case minusFour = -4
  case minusFive = -5
  case minusSix = -6
  case minusSeven = -7
}

public extension ConsecutiveDay {
  init?(days: Int) {
    self.init(rawValue: days)
  }
  
  var description: String {
    switch self {
    case .zero:
      return ""
      
    case .one:
      return "하루 더"
      
    case .two:
      return "이틀 더"
      
    case .three:
      return "3일 더"
      
    case .four:
      return "4일 더"
      
    case .five:
      return "5일 더"
      
    case .six:
      return "6일 더"
      
    case .seven:
      return "7일 더"
      
    case .minusOne:
      return "하루 덜"
      
    case .minusTwo:
      return "이틀 덜"
      
    case .minusThree:
      return "3일 덜"
      
    case .minusFour:
      return "4일 덜"
      
    case .minusFive:
      return "5일 덜"
      
    case .minusSix:
      return "6일 덜"
      
    case .minusSeven:
      return "7일 덜"
    }
  }
}
