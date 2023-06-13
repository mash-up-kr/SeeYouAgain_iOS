//
//  ToastType.swift
//  DesignSystem
//
//  Created by GREEN on 2023/06/12.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public enum ToastType {
  case basic
  case info
  case warning
  
  var foregroundColor: Color {
    return DesignSystem.Colors.grey20
  }
  var backgroundColor: Color {
    return DesignSystem.Colors.grey100.opacity(0.7)
  }
  
  var iconImage: Image? {
    switch self {
    case .basic:
      return nil
      
    case .info:
      return DesignSystem.Icons.toastBlue
      
    case .warning:
      return DesignSystem.Icons.toastRed
    }
  }
}
