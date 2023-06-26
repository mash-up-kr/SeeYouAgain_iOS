//
//  LongShortsItemView.swift
//  LongStorageNewsList
//
//  Created by 안상희 on 2023/06/25.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct LongShortsItemView: View {
  private let store: Store<LongShortsItemState, LongShortsItemAction>
  
  init(store: Store<LongShortsItemState, LongShortsItemAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      HStack(spacing: 0) {
        if viewStore.state.isInEditMode {
          Toggle("", isOn: viewStore.binding(get: \.isSelected, send: ._shortsItemSelectionChanged))
            .labelsHidden()
            .toggleStyle(ShortsToggleStyle())
            .frame(width: 24, height: 24)
          
          Spacer()
            .frame(width: 16)
        }
        
        LongShortsCardView(
          store: store.scope(
            state: \LongShortsItemState.cardState,
            action: LongShortsItemAction.cardAction
          )
        )
      }
    }
  }
}
