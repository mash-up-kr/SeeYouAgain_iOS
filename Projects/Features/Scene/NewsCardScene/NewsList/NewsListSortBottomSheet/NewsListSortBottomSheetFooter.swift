//
//  NewsListSortBottomSheetFooter.swift
//  Splash
//
//  Created by 김영균 on 2023/07/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystem
import SwiftUI

struct NewsListSortBottomSheetFooter: View {
  private let store: Store<Void, SortBottomSheetAction>
  
  init(store: Store<Void, SortBottomSheetAction>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(store) { viewStore in
      BottomButton(
        title: "확인",
        action: {
          viewStore.send(.confirmBottomButtonTapped)
        }
      )
    }
  }
}

