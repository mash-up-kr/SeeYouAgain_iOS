//
//  DateFilterBottomSheetFooter.swift
//  LongStorageNewsList
//
//  Created by 안상희 on 2023/07/06.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct DateFilterBottomSheetFooter: View {
  private let store: Store<Void, DateFilterBottomSheetAction>
  
  init(store: Store<Void, DateFilterBottomSheetAction>) {
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
