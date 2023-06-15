//
//  LetterBottom.swift
//  Main
//
//  Created by 김영균 on 2023/06/12.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import SwiftUI

private struct LetterBottomTriangle: Shape {
  private let heightRatio: CGFloat
  
  fileprivate init(heightRatio: CGFloat) {
    self.heightRatio = heightRatio
  }
  
  fileprivate func path(in rect: CGRect) -> Path {
    let bottomSpacing: CGFloat = 14 * heightRatio
    var path = Path()
    path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - bottomSpacing))
    path.addArc(
      tangent1End: CGPoint(x: rect.midX, y: rect.minY),
      tangent2End: CGPoint(x: rect.maxX, y: rect.maxY - bottomSpacing),
      radius: 20
    )
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomSpacing))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    return path
  }
}

struct LetterBottom: View {
  private enum Constant {
    static let bottomTriangleHeight: CGFloat = 74
  }
  
  private let deviceRatio: CGSize
  
  init(deviceRatio: CGSize) {
    self.deviceRatio = deviceRatio
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Spacer()
        OpaqueShape(
          color: DesignSystem.Colors.white.opacity(0.5),
          strokeColor: DesignSystem.Colors.white.opacity(0.5),
          shape: { LetterBottomTriangle(heightRatio: deviceRatio.height) }
        )
        .frame(height: Constant.bottomTriangleHeight * deviceRatio.height)
      }
    }
  }
}
