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
          
          if let newsCardType = NewsCardType(rawValue: viewStore.newsCard.category) {
            newsCardType.background
              .resizable()
              .scaledToFit()
              .padding(20)
              .opacity(viewStore.isFolded ? 1 : 0)
              .transition(.offset(x: 0, y: -10))
            
            LetterPaper(store: store.actionless, newsPaper: newsCardType.image)
              .frame(height: viewStore.isFolded ? 0 : geometry.size.height)
          }
          
          DesignSystem.Images.letterEnvelope
            .resizable()
            .scaledToFit()
          
          LetterTop(store: store.scope(state: \.isFolded).actionless)
        }
        .opacity(viewStore.opacity)
        .offset(y: viewStore.yOffset)
        .onTapGesture {
          viewStore.send(.newsCardTapped)
        }
      }
    }
  }
}
