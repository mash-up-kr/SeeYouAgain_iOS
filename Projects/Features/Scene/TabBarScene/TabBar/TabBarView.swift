//
//  TabBarView.swift
//  TabBar
//
//  Created by 안상희 on 2023/05/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import DesignSystem
import HotKeywordCoordinator
import MainCoordinator
import MyPageCoordinator
import SwiftUI

public struct TabBarView: View {
  private let store: Store<TabBarState, TabBarAction>
  
  public init(store: Store<TabBarState, TabBarAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      ShortsTabBarContainerView(
        selection: viewStore.binding(
          get: { $0.selectedTab },
          send: TabBarAction.tabSelected
        ),
        isHidden: viewStore.binding(
          get: { $0.isTabHidden },
          send: TabBarAction._setTabHiddenStatus
        )
      ) {
        HotKeywordCoordinatorView(
          store: store.scope(
            state: \TabBarState.hotKeyword,
            action: TabBarAction.hotKeyword
          )
        )
        .tabBarItem(
          tab: .hotKeyword,
          selection: viewStore.binding(get: { $0.selectedTab }, send: TabBarAction.tabSelected)
        )

        MainCoordinatorView(
          store: store.scope(
            state: \TabBarState.main,
            action: TabBarAction.main
          )
        )
        .tabBarItem(
          tab: .house,
          selection: viewStore.binding(get: { $0.selectedTab }, send: TabBarAction.tabSelected)
        )

        MyPageCoordinatorView(
          store: store.scope(
            state: \TabBarState.myPage,
            action: TabBarAction.myPage
          )
        )
        .tabBarItem(
          tab: .myPage,
          selection: viewStore.binding(get: { $0.selectedTab }, send: TabBarAction.tabSelected)
        )
      }
      .bottomSheet(
        isPresented: viewStore.binding(
          get: \.categoryBottomSheet.isPresented,
          send: {
            TabBarAction.categoryBottomSheet(
              CategoryBottomSheetAction._setIsPresented($0)
            )
          }
        ),
        headerArea: { CategoryBottomSheetHeader() },
        content: {
          CategoryBottomSheet(
            store: store.scope(
              state: \.categoryBottomSheet,
              action: TabBarAction.categoryBottomSheet
            )
          )
        },
        bottomArea: {
          BottomButton(
            title: "변경",
            action: {
              viewStore.send(.categoryBottomSheet(.updateButtonTapped))
            }
          )
        }
      )
    }
  }
}
