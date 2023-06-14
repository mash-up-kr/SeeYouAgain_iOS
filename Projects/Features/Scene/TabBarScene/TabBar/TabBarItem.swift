//
//  TabBarItem.swift
//  TabBar
//
//  Created by 안상희 on 2023/06/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import SwiftUI

public enum TabBarItem: Int, CaseIterable, Equatable {
  case hotKeyword = 0
  case house = 1
  case myPage = 2
  
  public var description: String {
    switch self {
    case .hotKeyword:
      return "Hot"
    case .house:
      return "Home"
    case .myPage:
      return "My"
    }
  }
  
  public var defaultIcon: Image {
    switch self {
    case .hotKeyword:
      return DesignSystem.Icons.defaultFire
    case .house:
      return DesignSystem.Icons.defaultHouse
    case .myPage:
      return DesignSystem.Icons.defaultUser
    }
  }
  
  public var selectedIcon: Image {
    switch self {
    case .hotKeyword:
      return DesignSystem.Icons.selectedFire
    case .house:
      return DesignSystem.Icons.selectedHouse
    case .myPage:
      return DesignSystem.Icons.selectedUser
    }
  }
  
  public var backgroundColor: Color {
    switch self {
    case .hotKeyword:
      return DesignSystem.Colors.red100
    case .house:
      return DesignSystem.Colors.blue50
    case .myPage:
      return DesignSystem.Colors.green100
    }
  }
  
  public var textColor: Color {
    switch self {
    case .hotKeyword:
      return Color.red
    case .house:
      return Color.blue
    case .myPage:
      return Color.green
    }
  }
}
