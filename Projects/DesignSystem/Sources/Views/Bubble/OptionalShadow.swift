//
//  OptionalShadow.swift
//  DesignSystem
//
//  Created by GREEN on 2023/06/03.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

public struct OptionalShadow: ViewModifier {
  public var color: Color?
  public var radius: CGFloat
  public var x: CGFloat
  public var y: CGFloat
  
  public func body(content: Content) -> some View {
    if let color = self.color {
      return AnyView(
        content.shadow(
          color: color,
          radius: radius,
          x: x,
          y: y
        )
      )
    } else {
      return AnyView(content)
    }
  }
}

public extension View {
  func optionalShadow(
    color: Color?,
    radius: CGFloat,
    x: CGFloat,
    y: CGFloat
  ) -> some View {
    self.modifier(
      OptionalShadow(
        color: color,
        radius: radius,
        x: x,
        y: y
      )
    )
  }
}
