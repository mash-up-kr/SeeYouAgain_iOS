//
//  LetterPaper.swift
//  Main
//
//  Created by 김영균 on 2023/06/16.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import SwiftUI

struct Paper: View {
  @Binding private var isFold: Bool
  
  init(isFold: Binding<Bool>) {
    self._isFold = isFold
  }
  
  var body: some View {
    Rectangle()
      .fill(
        LinearGradient(
          colors: [
            Color(hex: 0x45B2FF),
            Color(hex: 0x45BBFF)
          ],
          startPoint: .top,
          endPoint: .bottom
        )
      )
      .cornerRadius(10)
  }
}
