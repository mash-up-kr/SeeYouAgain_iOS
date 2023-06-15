//
//  LetterView.swift
//  Main
//
//  Created by 김영균 on 2023/06/11.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import SwiftUI

struct LetterView: View {
  @State private var isFold: Bool = true
  private let deviceRatio: CGSize
  
  init(deviceRatio: CGSize) {
    self.deviceRatio = deviceRatio
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .bottom) {
        // background
        Rectangle()
          .fill(DesignSystem.Colors.white.opacity(0.8))
          .frame(height: geometry.size.height / 2)
          .cornerRadius(isFold ? 20 : 0, corners: [.topLeft, .topRight])
          .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        
        LetterBottom(deviceRatio: deviceRatio)
          .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        
        LetterSide(deviceRatio: deviceRatio)
          .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        
        LetterTop(isFold: $isFold, deviceRatio: deviceRatio)
      }
      .onTapGesture {
        withAnimation(.easeInOut) {
          isFold.toggle()
        }
      }
    }
  }
}








fileprivate struct Paper: View {
  private enum Constant {
    static let horizontalPadding: CGFloat = 40
    static let beforeLetterHeight: CGFloat = 143
    static let afterLetterHeight: CGFloat = 321
  }
  
  @Binding private var fold: Bool
  private let deviceRatio: CGSize
  
  init(
    fold: Binding<Bool>,
    deviceRatio: CGSize
  ) {
    self._fold = fold
    self.deviceRatio = deviceRatio
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Spacer()
      Rectangle()
        .fill(DesignSystem.Colors.culture)
        .cornerRadius(10, corners: .allCorners)
        .frame(
          height: relativeHeight(
            fold ? Constant.beforeLetterHeight : Constant.afterLetterHeight
          )
        )
      Spacer()
    }
  }
  
  private func relativeHeight(_ height: CGFloat) -> CGFloat {
    return height * deviceRatio.height
  }
}
