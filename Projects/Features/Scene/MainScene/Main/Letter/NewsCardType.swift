//
//  NewsCardType.swift
//  CoreKit
//
//  Created by 김영균 on 2023/06/20.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import Foundation
import SwiftUI

enum NewsCardType: String {
  case politics = "POLITICS"
  case economic = "ECONOMIC"
  case society = "SOCIETY"
  case culture = "CULTURE"
  case world = "WORLD"
  case science = "SCIENCE"
}

extension NewsCardType {
  var image: Image {
    switch self {
    case .politics:
      return DesignSystem.Images.politicsNewscard
    case .economic:
      return DesignSystem.Images.economicNewscard
    case .society:
      return DesignSystem.Images.societyNewscard
    case .culture:
      return DesignSystem.Images.cultureNewscard
    case .world:
      return DesignSystem.Images.worldNewscard
    case .science:
      return DesignSystem.Images.scienceNewscard
    }
  }
  
  var background: Image {
    switch self {
    case .politics:
      return DesignSystem.Images.politicsBackground
    case .economic:
      return DesignSystem.Images.economicBackground
    case .society:
      return DesignSystem.Images.societyBackground
    case .culture:
      return DesignSystem.Images.cultureBackground
    case .world:
      return DesignSystem.Images.worldBackground
    case .science:
      return DesignSystem.Images.scienceBackground
    }
  }
}
