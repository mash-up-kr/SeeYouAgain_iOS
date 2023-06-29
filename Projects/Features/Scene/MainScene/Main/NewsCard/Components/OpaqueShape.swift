//
//  OpaqueShape.swift
//  Main
//
//  Created by 김영균 on 2023/06/11.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import SwiftUI

struct OpaqueShape<Content: Shape, Color: ShapeStyle>: View {
  private let color: Color
  private let strokeColor: Color
  private let strokeOpacity: CGFloat
  private let degree: Double
  private let shape: Content
  
  init(
    color: Color,
    strokeColor: Color,
    strokeOpacity: CGFloat,
    degree: Double = 0,
    shape: @escaping () -> Content
  ) {
    self.color = color
    self.strokeColor = strokeColor
    self.strokeOpacity = strokeOpacity
    self.degree = degree
    self.shape = shape()
  }
  
  var body: some View {
    shape
      .stroke(color.opacity(strokeOpacity), lineWidth: 0.5)
      .background(color)
      .clipShape(shape)
      .rotationEffect(.degrees(degree))
  }
}
