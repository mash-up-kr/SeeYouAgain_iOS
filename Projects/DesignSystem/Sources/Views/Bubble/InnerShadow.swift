//
//  InnerShadow.swift
//  DesignSystem
//
//  Created by GREEN on 2023/06/03.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct InnerShadow: ViewModifier {
  public var color: Color
  public var radius: CGFloat
  public var offset: CGSize
  
  public func body(content: Content) -> some View {
    content
      .overlay(
        Circle()
          .stroke(color, lineWidth: radius)
          .offset(offset)
          .mask(
            Circle()
              .fill(
                LinearGradient(
                  gradient: Gradient(colors: [Color.white, Color.clear]),
                  startPoint: .top,
                  endPoint: .bottom
                )
              )
          )
          .blur(radius: radius)
      )
  }
}
