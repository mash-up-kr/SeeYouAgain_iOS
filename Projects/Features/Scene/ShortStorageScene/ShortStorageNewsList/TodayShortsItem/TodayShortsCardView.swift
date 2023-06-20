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
      HStack(alignment: .top, spacing: 16) {
        // TODO: 추후 이미지 변경 필요
        Color.blue
          .frame(width: 60, height: 74)
        
        Text(viewStore.state.shortsNews.keywords)
          .font(.b16)
          .foregroundColor(DesignSystem.Colors.grey90)
          .frame(width: 187, height: 74, alignment: .topLeading)
        
        // TODO: 오른쪽 화살표 버튼 추가 필요
      }
    }
  }
}
