//
//  TodayShortsCardView.swift
//  ShortStorageNewsList
//
//  Created by 안상희 on 2023/06/18.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import SwiftUI

struct TodayShortsCardView: View {
  private let store: Store<TodayShortsCardState, TodayShortsCardAction>
  
  init(store: Store<TodayShortsCardState, TodayShortsCardAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      HStack(alignment: .top, spacing: 0) {
        HStack {
          Text(viewStore.state.shortsNews.hashtagString())
            .font(.b16)
            .foregroundColor(DesignSystem.Colors.grey90)
          Spacer()
        }
        
        Spacer()
          .frame(width: 16)
        
        CategoryType(uppercasedName: viewStore.state.shortsNews.category)?.image
      }
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 16)
      .padding(.vertical, 20)
      .background(DesignSystem.Colors.grey20)
      .cornerRadius(16)
      .onTapGesture {
        if viewStore.isCardSelectable {
          viewStore.send(.cardTapped)
        }
      }
    }
  }
}

fileprivate extension CategoryType {
  var image: Image {
    switch self {
    case .politics:
      return DesignSystem.Images.cardPolitics
    case .economic:
      return DesignSystem.Images.cardEconomics
    case .society:
      return DesignSystem.Images.cardSociety
    case .world:
      return DesignSystem.Images.cardWorld
    case .culture:
      return DesignSystem.Images.cardCulture
    case .science:
      return DesignSystem.Images.cardIt
    }
  }
}
