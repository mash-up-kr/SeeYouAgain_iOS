//
//  TabBarCoordinatorView.swift
//  Coordinator
//
//  Created by 안상희 on 2023/05/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import HotKeywordCoordinator
import MainCoordinator
import MyPageCoordinator
import SwiftUI

public struct TabBarCoordinatorView: View {
  private let store: Store<TabBarCoordinatorState, TabBarCoordinatorAction>
  
  public init(store: Store<TabBarCoordinatorState, TabBarCoordinatorAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store, observe: \.selectedTab) { viewStore in
      TabView(selection: viewStore.binding(get: { $0 }, send: TabBarCoordinatorAction.tabSelected)) {
        HotKeywordCoordinatorView(
          store: store.scope(
            state: \TabBarCoordinatorState.hotKeyword,
            action: TabBarCoordinatorAction.hotKeyword
          )
        )
        .tabItem {
          Text("HotKeyword")
        }
        .tag(Tab.hotKeyword)
        
        MainCoordinatorView(
          store: store.scope(
            state: \TabBarCoordinatorState.main,
            action: TabBarCoordinatorAction.main
          )
        )
        .tabItem {
          Text("Main")
        }
        .tag(Tab.main)
        
        MyPageCoordinatorView(
          store: store.scope(
            state: \TabBarCoordinatorState.myPage,
            action: TabBarCoordinatorAction.myPage
          )
        )
        .tabItem {
          Text("MyPage")
        }
        .tag(Tab.myPage)
      }
    }    
  }
}
