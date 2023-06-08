//
//  CategoryType.swift
//  Main
//
//  Created by 김영균 on 2023/06/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import SwiftUI

public enum CategoryType: String {
  case economy = "경제"
  case itscience = "IT/과학"
  case lifeCulture = "생활/문화"
  case politics = "정치"
  case society = "사회"
  case world = "세계"
}

extension CategoryType {
  var name: String {
    switch self {
    case .economy:
      return "경제"
    case .itscience:
      return "IT/과학"
    case .lifeCulture:
      return "생활/문화"
    case .politics:
      return "정치"
    case .society:
      return "사회"
    case .world:
      return "세계"
    }
  }
  var icon: Image {
    switch self {
    default:
      return DesignSystem.Icons.badge
    }
  }
  
  var size: CGFloat {
    switch self {
    default:
      return 24
    }
  }
}
