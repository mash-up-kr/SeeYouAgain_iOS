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
      .apply(content: { view in
        WithViewStore(store.scope(state: \.toastMessage)) { toastMessageViewStore in
          view.toast(
            text: toastMessageViewStore.state,
            toastType: buildToastType(message: toastMessageViewStore.state),
            toastOffset: -38
          )
        }
      })
      .bottomSheet(
        backgroundColor: DesignSystem.Colors.white.opacity(0.62).blurEffect(),
        isPresented: viewStore.binding(
          get: \.categoryBottomSheet.isPresented,
          send: {
            TabBarAction.categoryBottomSheet(
              BottomSheetAction._setIsPresented($0)
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
            disabled: viewStore.categoryBottomSheet.selectedCategories.isEmpty,
            action: {
              viewStore.send(.categoryBottomSheet(.updateButtonTapped))
            }
          )
        }
      )
      .apply(content: { view in
        WithViewStore(store.scope(state: \.categoryBottomSheet.toastMessage)) { toastMessageViewStore in
          view.toast(
            text: toastMessageViewStore.state,
            toastType: .warning,
            toastOffset: -396
          )
        }
      })
    }
  }
}

private func buildToastType(message: String?) -> ToastType {
  guard let message = message else { return .basic }
  if message == "오늘 읽을 숏스에 저장됐어요:)" {
    return .info
  }
  if message == "인터넷이 불안정해서 저장되지 못했어요." {
    return .warning
  }
  return .basic
}
