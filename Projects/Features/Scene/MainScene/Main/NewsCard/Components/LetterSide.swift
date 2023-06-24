//
//  LetterSide.swift
//  Main
//
//  Created by 김영균 on 2023/06/11.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import SwiftUI

private struct LetterSideTriangle: Shape {
  func path(in rect: CGRect) -> Path {
    let space: CGFloat = 21.0
    var path = Path()
    path.move(to: CGPoint(x: rect.minX, y: rect.minY))
    path.addArc(
      tangent1End: CGPoint(x: rect.minX + space, y: rect.minY),
      tangent2End: CGPoint(x: rect.maxX, y: rect.midY),
      radius: 8
    )
    path.addArc(
      tangent1End: CGPoint(x: rect.maxX, y: rect.midY),
      tangent2End: CGPoint(x: rect.minX + space, y: rect.maxY),
      radius: 10
    )
    path.addArc(
      tangent1End: CGPoint(x: rect.minX + space, y: rect.maxY),
      tangent2End: CGPoint(x: rect.minX, y: rect.maxY),
      radius: 6
    )
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
    return path
  }
}

struct LetterSide: View {
  private enum Constant {
    static let bottomTriangleHeight: CGFloat = 74
    static let sideTriangleHeight: CGFloat = 112
    static let sideTriangleWidth: CGFloat = 148
  }
  
  private let deviceRatio: CGSize
  
  init(deviceRatio: CGSize) {
    self.deviceRatio = deviceRatio
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Spacer()
        
        HStack(spacing: contentSpacing(geometry)) {
          left
          right
        }
      }
    }
  }
  
  private var left: some View {
    OpaqueShape(
      color: DesignSystem.Colors.white.opacity(0.6),
      strokeOpacity: 0.7,
      shape: { LetterSideTriangle() }
    )
    .frame(
      width: Constant.sideTriangleWidth * deviceRatio.width,
      height: Constant.sideTriangleHeight * deviceRatio.height
    )
  }
  
  private var right: some View {
    OpaqueShape(
      color: DesignSystem.Colors.white.opacity(0.6),
      strokeOpacity: 0.7,
      shape: { LetterSideTriangle() }
    )
    .frame(
      width: Constant.sideTriangleWidth * deviceRatio.width,
      height: Constant.sideTriangleHeight * deviceRatio.height
    )
    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
  }
  
  private func contentSpacing(_ geometry: GeometryProxy) -> CGFloat {
    return geometry.size.width - 2 * (Constant.sideTriangleWidth * deviceRatio.width)
  }
}
