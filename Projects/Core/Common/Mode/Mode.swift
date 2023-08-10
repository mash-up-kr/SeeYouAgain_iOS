//
//  Mode.swift
//  CoreKit
//
//  Created by 김영균 on 2023/08/07.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public enum Mode: Equatable {
  case basic
  case interestCompany
}

public extension Mode {
  var title: String {
    switch self {
    case .basic:
      return "일반모드"
      
    case .interestCompany:
      return "관심기업 모드"
    }
  }
  
  var description: String {
    switch self {
    case .basic:
      return "정치, 경제, 사회, IT 별\n뉴스보기"
      
    case .interestCompany:
      return "삼성, 카카오, 네이버 별\n뉴스보기"
    }
  }
}
