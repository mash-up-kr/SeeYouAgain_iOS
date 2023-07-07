//
//  LetterPaper.swift
//  Main
//
//  Created by 김영균 on 2023/06/16.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import SwiftUI

struct LetterPaper: View {
  private let store: Store<NewsCardState, Never>
  private let newsPaper: Image
  
  init(
    store: Store<NewsCardState, Never>,
    newsPaper: Image
  ) {
    self.store = store
    self.newsPaper = newsPaper
  }
  
  var body: some View {
    WithViewStore(store, observe: \.isFolded) { viewStore in
      VStack {
        Spacer()
        
        newsPaper
          .resizable()
          .offset(y: -5)
          .overlay {
            NewsCardContent(store: store)
          }
          .animation(.interpolatingSpring(stiffness: 300, damping: 20).delay(0.3), value: viewStore.state)
      }
      .opacity(viewStore.state ? 0 : 1)
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
        
        if let categoryType = CategoryType(uppercasedName: viewStore.newsCard.category) {
          Category(name: categoryType.rawValue)
        }
        
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
      ForEach(0..<min(4, keywords.count), id: \.self) { index in
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
