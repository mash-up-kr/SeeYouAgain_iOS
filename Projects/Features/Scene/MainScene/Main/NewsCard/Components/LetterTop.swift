//
//  LetterTop.swift
//  Main
//
//  Created by 김영균 on 2023/06/11.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import SwiftUI

private struct LetterTopTriangle: Shape {
  private let deviceRatio: CGSize
  
  fileprivate init(deviceRatio: CGSize) {
    self.deviceRatio = deviceRatio
  }
  
  fileprivate func path(in rect: CGRect) -> Path {
    let topSpacing: CGFloat = 30 * deviceRatio.height
    let cap: CGFloat = 76.5 * deviceRatio.height
    var path = Path()
    path.move(to: CGPoint(x: rect.minX, y: rect.minY))
    path.addArc(
      tangent1End: CGPoint(x: rect.minX, y: rect.minY + cap),
      tangent2End: CGPoint(x: rect.midX, y: rect.maxY),
      radius: 6
    )
    path.addArc(
      tangent1End: CGPoint(x: rect.midX, y: rect.maxY - topSpacing),
      tangent2End: CGPoint(x: rect.maxX, y: rect.minY + cap),
      radius: 30
    )
    path.addArc(
      tangent1End: CGPoint(x: rect.maxX, y: rect.minY + cap),
      tangent2End: CGPoint(x: rect.maxX, y: rect.minY),
      radius: 6
    )
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
    return path
  }
}

struct LetterTop: View {
  @Binding private var isFold: Bool
  private let deviceRatio: CGSize
  
  init(isFold: Binding<Bool>, deviceRatio: CGSize) {
    self._isFold = isFold
    self.deviceRatio = deviceRatio
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Spacer()
        
        OpaqueShape(
          color: LinearGradient(
            colors: [
              DesignSystem.Colors.white,
              DesignSystem.Colors.white.opacity(0.5)
          ],
            startPoint: .top,
            endPoint: .bottom
          ),
          strokeColor: LinearGradient(
            colors: [
              DesignSystem.Colors.white,
              DesignSystem.Colors.white.opacity(0)
          ],
            startPoint: .top,
            endPoint: .bottom
          ),
          strokeOpacity: 0.6,
          shape: { LetterTopTriangle(deviceRatio: deviceRatio) }
        )
        .frame(height: geometry.size.height / 2)
        .cornerRadius(isFold ? 20 : 0, corners: [.topLeft, .topRight])
        .opacity(isFold ? 1 : 0)
        .animation(.easeInOut, value: isFold)
      }
      .rotation3DEffect(.degrees(isFold ? 0 : 180), axis: (x: 1, y: 0, z: 0))
    }
  }
}
