//
//  OpaqueShape.swift
//  Main
//
//  Created by 김영균 on 2023/06/11.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import SwiftUI

struct OpaqueShape<Content: Shape>: View {
  private let color: Color
  private let strokeOpacity: CGFloat
  private let degree: Double
  private let shape: Content
  
  init(
    color: Color,
    strokeOpacity: CGFloat,
    degree: Double = 0,
    shape: @escaping () -> Content
  ) {
    self.color = color
    self.strokeOpacity = strokeOpacity
    self.degree = degree
    self.shape = shape()
  }
  
  var body: some View {
    shape
      .stroke(
        .linearGradient(
          colors: [
            DesignSystem.Colors.white,
            DesignSystem.Colors.white.opacity(0)
          ],
          startPoint: .top,
          endPoint: .bottom
        ),
        lineWidth: 0.3
      )
      .background(Material.regularMaterial)
      .clipShape(shape)
      .rotationEffect(.degrees(degree))
  }
}
