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
  private let strokeColor: Color
  private let degree: Double
  private let shape: Content
  
  init(
    color: Color,
    strokeColor: Color = .clear,
    degree: Double = 0,
    shape: @escaping () -> Content
  ) {
    self.color = color
    self.strokeColor = strokeColor
    self.degree = degree
    self.shape = shape()
  }
  
  var body: some View {
    color.blurEffect()
      .clipShape(shape)
      .rotationEffect(.degrees(degree))
  }
}
