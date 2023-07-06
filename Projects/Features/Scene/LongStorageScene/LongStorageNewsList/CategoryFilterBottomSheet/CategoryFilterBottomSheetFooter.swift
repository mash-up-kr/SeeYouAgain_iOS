//
//  CategoryFilterBottomSheetFooter.swift
//  Splash
//
//  Created by 김영균 on 2023/07/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import SwiftUI

struct CategoryFilterBottomSheetFooter: View {
  private let store: Store<CategoryFilterBottomSheetState, CategoryFilterBottomSheetAction>
  
  init(store: Store<CategoryFilterBottomSheetState, CategoryFilterBottomSheetAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store, observe: \.selectedCategories) { viewStore in
      BottomButton(
        title: "확인",
        disabled: viewStore.state.isEmpty,
        action: {
          viewStore.send(.confirmBottomButtonTapped)
        }
      )
    }
  }
}
