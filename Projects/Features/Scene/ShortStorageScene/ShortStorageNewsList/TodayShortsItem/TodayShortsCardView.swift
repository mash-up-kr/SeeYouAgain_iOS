//
//  TodayShortsCardView.swift
//  ShortStorageNewsList
//
//  Created by 안상희 on 2023/06/18.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

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
        // TODO: 디자인 확정시 카드 이미지 변경 필요
        DesignSystem.Images.earthCard
        
        Spacer()
          .frame(width: 16)
        
        HStack {
          Text(viewStore.state.shortsNews.keywords)
            .font(.b16)
            .foregroundColor(DesignSystem.Colors.grey90)
          Spacer()
        }
        
        if viewStore.isCardSelectable {
          // 선택할 수 있을 때만 화살표 있음
          Spacer()
            .frame(width: 16)
          
          Button {
            viewStore.send(.rightButtonTapped)
          } label: {
            DesignSystem.Icons.iconChevronRight
              .frame(width: 16, height: 16)
          }
        }
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
