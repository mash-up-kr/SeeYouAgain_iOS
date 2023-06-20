//
//  CategoryType.swift
//  CoreKit
//
//  Created by GREEN on 2023/06/03.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import Foundation
import SwiftUI

public enum CategoryType: String, CaseIterable {
  case politics = "정치"
  case economic = "경제"
  case society = "사회"
  case world = "세계"
  case culture = "생활/문화"
  case science = "IT/과학"
  
  public var uppercasedName: String {
    return String(describing: self).uppercased()
  }
  
  public var defaultIcon: Image {
    switch self {
    case .politics:
      return DesignSystem.Icons.politics
    case .economic:
      return DesignSystem.Icons.economics
    case .society:
      return DesignSystem.Icons.society
    case .world:
      return DesignSystem.Icons.world
    case .culture:
      return DesignSystem.Icons.culture
    case .science:
      return DesignSystem.Icons.science
    }
  }
  
  public var selectedIcon: Image {
    switch self {
    case .politics:
      return DesignSystem.Icons.selectedPolitics
    case .economic:
      return DesignSystem.Icons.selectedEconomics
    case .society:
      return DesignSystem.Icons.selectedSociety
    case .world:
      return DesignSystem.Icons.selectedWorld
    case .culture:
      return DesignSystem.Icons.selectedCulture
    case .science:
      return DesignSystem.Icons.selectedScience
    }
  }
  
  public var defaultColor: Color {
    return DesignSystem.Colors.white.opacity(0.28)
  }
  
  public var pressedColor: Color {
    return DesignSystem.Colors.white.opacity(0.5)
  }
}
