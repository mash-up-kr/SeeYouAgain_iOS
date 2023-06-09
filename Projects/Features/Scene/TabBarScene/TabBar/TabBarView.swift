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
      TabView(selection: viewStore.binding(get: { $0.selectedTab }, send: TabBarAction.tabSelected)) {
        HotKeywordCoordinatorView(
          store: store.scope(
            state: \TabBarState.hotKeyword,
            action: TabBarAction.hotKeyword
          )
        )
        .tabItem {
          Text("HotKeyword")
        }
        .tag(Tab.hotKeyword)
        
        MainCoordinatorView(
          store: store.scope(
            state: \TabBarState.main,
            action: TabBarAction.main
          )
        )
        .tabItem {
          Text("Main")
        }
        .tag(Tab.main)
        
        MyPageCoordinatorView(
          store: store.scope(
            state: \TabBarState.myPage,
            action: TabBarAction.myPage
          )
        )
        .tabItem {
          Text("MyPage")
        }
        .tag(Tab.myPage)
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
