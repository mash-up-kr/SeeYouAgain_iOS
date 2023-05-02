//
//  DividerHorizontal.swift
//  DesignSystem
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct DividerHorizontal: View {
  let color: BackgroundColor
  let height: Height
  
  public init(
    color: BackgroundColor = .gray,
    height: Height
  ) {
    self.color = color
    self.height = height
  }
  
  public var body: some View {
    Rectangle()
      .foregroundColor(color.usage)
      .frame(maxWidth: .infinity)
      .frame(height: height.value)
  }
}

extension DividerHorizontal {
  public enum BackgroundColor {
    case gray
    
    var usage: Color {
      switch self {
      case .gray:
        return .gray.opacity(0.2)
      }
    }
  }
  
  public enum Height {
    case _1
    
    var value: CGFloat {
      switch self {
      case ._1: return 1
      }
    }
  }
}
