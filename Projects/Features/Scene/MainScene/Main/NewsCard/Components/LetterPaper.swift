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
  private let newsPaper: Image
  
  init(
    isFold: Binding<Bool>,
    newsPaper: Image
  ) {
    self._isFold = isFold
    self.newsPaper = newsPaper
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        Spacer()
        
        // TODO: API 연결 후 해야하는 작업
        // 1. 카테고리에 따라 편지 색 바꾸기
        // 2. 편지에 키워드 적기
        newsPaper
          .resizable()
          .frame(height: isFold ? 0 : geometry.size.height - 5)
          .offset(y: -5)
          .animation(.interpolatingSpring(stiffness: 300, damping: 20).delay(0.3), value: isFold)
      }
      .opacity(isFold ? 0 : 1)
    }
  }
}
