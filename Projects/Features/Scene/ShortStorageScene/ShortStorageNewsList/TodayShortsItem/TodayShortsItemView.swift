//
//  TodayShortsItemView.swift
//  ShortStorageNewsList
//
//  Created by 안상희 on 2023/06/18.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct TodayShortsItemView: View {
  private let store: Store<TodayShortsItemState, TodayShortsItemAction>
  
  init(store: Store<TodayShortsItemState, TodayShortsItemAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 0) {
        if viewStore.state.isInEditMode {
          Toggle("", isOn: viewStore.binding(get: \.isSelected, send: .shortsItemSelectionChanged))
            .labelsHidden()
            .toggleStyle(ShortsToggleStyle())
            .frame(width: 24, height: 24)
          
          Spacer()
            .frame(width: 16)
        }
        
        TodayShortsCardView(
          store: store.scope(
            state: \TodayShortsItemState.cardState,
            action: TodayShortsItemAction.cardAction
          )
        )
      }
    }
  }
}
