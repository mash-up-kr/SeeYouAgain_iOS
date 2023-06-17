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
        DesignSystem.Images.letterBackground
          .resizable()
          .scaledToFit()
          .opacity(isFold ? 0 : 1)
          .animation(.easeInOut.delay(0.3), value: isFold)
        
        LetterPaper(isFold: $isFold)
          .padding(.all, 20)
        
        DesignSystem.Images.imgPolitics
          .resizable()
          .scaledToFit()
          .offset(y: -10)
          .padding(.all, 20)
          .frame(width: isFold ? 0 : geometry.size.width)
          .animation(.interpolatingSpring(stiffness: 300, damping: 20).delay(0.3), value: isFold)
          .opacity(isFold ? 0 : 1)
        
        LetterBottom(deviceRatio: deviceRatio)
          .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        
        LetterSide(deviceRatio: deviceRatio)
          .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        
        LetterTop(isFold: $isFold, deviceRatio: deviceRatio)
      }
    }
  }
}
