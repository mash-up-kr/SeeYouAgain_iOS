//
//  NewsCardView.swift
//  Main
//
//  Created by 김영균 on 2023/06/11.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct NewsCardView: View {
  private let store: Store<NewsCardState, NewsCardAction>
  
  init(store: Store<NewsCardState, NewsCardAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      GeometryReader { geometry in
        ZStack(alignment: .bottom) {
          DesignSystem.Images.letterBackground
            .resizable()
            .scaledToFit()
            .opacity(viewStore.isFolded ? 0 : 1)
            .animation(.easeInOut.delay(0.3), value: viewStore.isFolded)
          
          if let newsCardType = NewsCardType(rawValue: viewStore.newsCard.category) {
            if viewStore.isFolded {
              newsCardType.background
                .resizable()
                .scaledToFit()
                .padding(20)
                .transition(.offset(x: 0, y: -10))
            }
            
            LetterPaper(
              store: store,
              newsPaper: newsCardType.image
            )
          }
          
          LetterBottom(deviceRatio: viewStore.layout.ratio)
            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
          
          LetterSide(deviceRatio: viewStore.layout.ratio)
            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
          
          LetterTop(
            isFold: viewStore.binding(
              get: \.isFolded,
              send: { ._setIsFolded($0) }
            ),
            deviceRatio: viewStore.layout.ratio
          )
        }
      }
    }
  }
}
