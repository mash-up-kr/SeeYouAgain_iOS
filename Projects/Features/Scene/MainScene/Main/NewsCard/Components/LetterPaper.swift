//
//  LetterPaper.swift
//  Main
//
//  Created by 김영균 on 2023/06/16.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct LetterPaper: View {
  private let store: Store<NewsCardState, NewsCardAction>
  private let newsPaper: Image
  
  init(
    store: Store<NewsCardState, NewsCardAction>,
    newsPaper: Image
  ) {
    self.store = store
    self.newsPaper = newsPaper
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      GeometryReader { geometry in
        VStack {
          Spacer()
          
          newsPaper
            .resizable()
            .frame(height: viewStore.isFolded ? 0 : geometry.size.height - 5)
            .offset(y: -5)
            .overlay {
              NewsCardContent(store: store.actionless)
            }
            .animation(.interpolatingSpring(stiffness: 300, damping: 20).delay(0.3), value: viewStore.isFolded)
        }
        .opacity(viewStore.isFolded ? 0 : 1)
      }
    }
  }
}

private struct NewsCardContent: View {
  fileprivate let store: Store<NewsCardState, Never>
  
  fileprivate var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        Spacer()
          .frame(height: 66 * viewStore.layout.ratio.height)
        
        Category(name: viewStore.newsCard.category.rawValue)

        Spacer()
          .frame(height: 16)

        Keywords(keywords: viewStore.newsCard.keywords)

        Spacer()
      }
      .padding(.horizontal, 44 * viewStore.layout.ratio.width)
      .opacity(viewStore.isFolded ? 0 : 1)
    }
  }
}

private struct Category: View {
  fileprivate let name: String
  
  fileprivate var body: some View {
    HStack {
      Text(name)
        .font(.r14)
        .foregroundColor(DesignSystem.Colors.white)
      
      Spacer()
    }
  }
}

private struct Keywords: View {
  fileprivate let keywords: [String]
  
  fileprivate var body: some View {
    VStack(spacing: 12) {
      ForEach(keywords.indices, id: \.self) { index in
        HStack {
          Text("#\(keywords[index])")
            .font(.b20)
            .foregroundColor(DesignSystem.Colors.white)
            .lineLimit(1)
          
          Spacer()
        }
      }
    }
  }
}
