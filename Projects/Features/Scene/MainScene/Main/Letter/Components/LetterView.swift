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
  @Binding private var isFold: Bool
  private let deviceRatio: CGSize
  
  init(isFold: Binding<Bool>, deviceRatio: CGSize) {
    self._isFold = isFold
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
        
        Paper(isFold: $isFold)
          .padding(.all, 20)
          .frame(
            height: isFold ? geometry.size.height / 2 : geometry.size.height
          )
          .animation(.interpolatingSpring(stiffness: 300, damping: 15).delay(0.2), value: isFold)
        
        LetterBottom(deviceRatio: deviceRatio)
          .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        
        LetterSide(deviceRatio: deviceRatio)
          .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        
        LetterTop(isFold: $isFold, deviceRatio: deviceRatio)
      }
    }
  }
}
