//
//  LetterPaper.swift
//  Main
//
//  Created by 김영균 on 2023/06/16.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import SwiftUI

struct LetterPaper: View {
  @Binding private var isFold: Bool
  
  init(isFold: Binding<Bool>) {
    self._isFold = isFold
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Spacer()
        
        // TODO: API 연결 후 해야하는 작업
        // 1. 카테고리에 따라 편지 색 바꾸기
        // 2. 편지에 키워드 적기
        DesignSystem.Images.letter
          .resizable()
          .offset(y: isFold ? 0 : -10)
          .frame(height: isFold ? 0 : geometry.size.height)
          .animation(.interpolatingSpring(stiffness: 300, damping: 20).delay(0.3), value: isFold)
      }
      .opacity(isFold ? 0 : 1)
    }
  }
}
