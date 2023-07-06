//
//  DateFilterBottomSheet.swift
//  LongStorageNewsList
//
//  Created by 안상희 on 2023/07/06.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct DateFilterBottomSheet: ViewModifier {
  private let store: Store<LongStorageNewsListState, LongStorageNewsListAction>
  
  init(store: Store<LongStorageNewsListState, LongStorageNewsListAction>) {
    self.store = store
  }
  
  func body(content: Content) -> some View {
    WithViewStore(store) { viewStore in
      content
        .bottomSheet(
          isPresented: viewStore.binding(
            get: \.dateFilterBottomSheetState.isPresented,
            send: { .dateFilterBottomSheet(._setIsPresented($0)) }
          ),
          headerArea: { DateFilterBottomSheetHeader() },
          content: {
            DateFilterBottomSheetContent(
              store: store.scope(
                state: \.dateFilterBottomSheetState,
                action: LongStorageNewsListAction.dateFilterBottomSheet
              )
            )
          },
          bottomArea: {
            DateFilterBottomSheetFooter(
              store: store.scope(
                state: \.dateFilterBottomSheetState,
                action: LongStorageNewsListAction.dateFilterBottomSheet
              )
            )
          }
        )
    }
  }
}

extension View {
  func dateFilterBottomSheet(store: Store<LongStorageNewsListState, LongStorageNewsListAction>) -> some View {
    modifier(DateFilterBottomSheet(store: store))
  }
}
