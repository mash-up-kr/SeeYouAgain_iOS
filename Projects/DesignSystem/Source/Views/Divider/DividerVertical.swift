//
//  DividerVertical.swift
//  DesignSystem
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct DividerVertical: View {
  let color: BackgroundColor
  let width: Width
  
  public init(
    color: BackgroundColor = .gray,
    width: Width
  ) {
    self.color = color
    self.width = width
  }
  
  public var body: some View {
    Rectangle()
      .foregroundColor(color.usage)
      .frame(width: width.value)
      .frame(maxHeight: .infinity)
  }
}

extension DividerVertical {
  public enum BackgroundColor {
    case gray
    
    var usage: Color {
      switch self {
      case .gray:
        return .gray.opacity(0.2)
      }
    }
  }
  
  public enum Width {
    case _1
    
    var value: CGFloat {
      switch self {
      case ._1: return 1
      }
    }
  }
}
