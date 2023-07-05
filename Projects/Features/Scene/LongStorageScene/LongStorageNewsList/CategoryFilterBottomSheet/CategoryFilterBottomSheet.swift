//
//  CategoryFilterBottomSheet.swift
//  Splash
//
//  Created by 김영균 on 2023/07/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

struct CategoryFilterBottomSheet: ViewModifier {
  private let store: Store<LongStorageNewsListState, LongStorageNewsListAction>
  
  init(store: Store<LongStorageNewsListState, LongStorageNewsListAction>) {
    self.store = store
  }
  
  func body(content: Content) -> some View {
    WithViewStore(store) { viewStore in
      content
        .bottomSheet(
          isPresented: viewStore.binding(
            get: \.categoryFilterBottomSheetState.isPresented,
            send: { .categoryFilterBottomSheet(._setIsPresented($0)) }
          ),
          headerArea: {
            CategoryFilterBottomSheetHeader(
              store: store.scope(
                state: \.categoryFilterBottomSheetState,
                action: LongStorageNewsListAction.categoryFilterBottomSheet
              )
            )
            
          },
          content: {
            CategoryFilterBottomSheetContent(
              store: store.scope(
                state: \.categoryFilterBottomSheetState,
                action: LongStorageNewsListAction.categoryFilterBottomSheet
              )
            )
          },
          bottomArea: {
            CategoryFilterBottomSheetFooter(
              store: store.scope(
                state: \.categoryFilterBottomSheetState,
                action: LongStorageNewsListAction.categoryFilterBottomSheet
              )
            )
          }
        )
    }
  }
}

extension View {
  func filterBottomSheet(store: Store<LongStorageNewsListState, LongStorageNewsListAction>) -> some View {
    modifier(CategoryFilterBottomSheet(store: store))
  }
}
