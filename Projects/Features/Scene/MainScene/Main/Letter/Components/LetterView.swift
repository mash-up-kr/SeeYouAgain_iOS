//
//  LetterView.swift
//  Main
//
//  Created by 김영균 on 2023/06/11.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import DesignSystem
import Models
import SwiftUI

struct LetterView: View {
  @Binding private var isFold: Bool
  private let newsCard: NewsCard
  private let deviceRatio: CGSize
  
  init(
    isFold: Binding<Bool>,
    newsCard: NewsCard,
    deviceRatio: CGSize
  ) {
    self._isFold = isFold
    self.newsCard = newsCard
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
        
        if let newsCardType = NewsCardType(rawValue: newsCard.cateogry) {
          if isFold {
            newsCardType.background
              .resizable()
              .scaledToFit()
              .padding(20)
              .transition(.offset(x: 0, y: -10))
          }
          
          LetterPaper(isFold: $isFold, newsPaper: newsCardType.image)
        }
        
        LetterBottom(deviceRatio: deviceRatio)
          .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        
        LetterSide(deviceRatio: deviceRatio)
          .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        
        LetterTop(isFold: $isFold, deviceRatio: deviceRatio)
      }
    }
  }
}
