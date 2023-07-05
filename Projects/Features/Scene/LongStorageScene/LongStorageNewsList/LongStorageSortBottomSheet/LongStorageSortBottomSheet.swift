//
//  LongStorageSortBottomSheet.swift
//  LongStorageNewsList
//
//  Created by 김영균 on 2023/07/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct LongStorageSortBottomSheet: ViewModifier {
  private let store: Store<LongStorageNewsListState, LongStorageNewsListAction>
  
  init(store: Store<LongStorageNewsListState, LongStorageNewsListAction>) {
    self.store = store
  }
  
  func body(content: Content) -> some View {
    WithViewStore(store) { viewStore in
      content
        .bottomSheet(
          isPresented: viewStore.binding(
            get: \.sortBottomSheetState.isPresented,
            send: { .sortBottomSheet(._setIsPresented($0)) }
          ),
          headerArea: { LongStorageSortBottomSheetHeader() },
          content: {
            LongStorageSortBottomSheetContent(
              store: store.scope(
                state: \.sortBottomSheetState,
                action: LongStorageNewsListAction.sortBottomSheet
              )
            )
          },
          bottomArea: {
            LongStorageSortBottomSheetFooter(
              store: store.scope(
                state: \.sortBottomSheetState,
                action: LongStorageNewsListAction.sortBottomSheet
              )
              .stateless
            )
          }
        )
    }
  }
}

extension View {
  func longStorageSortBottomSheet(store: Store<LongStorageNewsListState, LongStorageNewsListAction>) -> some View {
    modifier(LongStorageSortBottomSheet(store: store))
  }
}
