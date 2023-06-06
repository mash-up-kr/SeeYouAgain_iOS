//
//  TabBarCore.swift
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

public struct TabBarState: Equatable {
  public var hotKeyword: HotKeywordCoordinatorState
  public var main: MainCoordinatorState
  public var myPage: MyPageCoordinatorState
  public var selectedTab: TabBarItem = .house
  
  public init(
    hotKeyword: HotKeywordCoordinatorState,
    main: MainCoordinatorState,
    myPage: MyPageCoordinatorState
  ) {
    self.hotKeyword = hotKeyword
    self.main = main
    self.myPage = myPage
  }
}

public enum TabBarAction {
  case hotKeyword(HotKeywordCoordinatorAction)
  case main(MainCoordinatorAction)
  case myPage(MyPageCoordinatorAction)
  case tabSelected(TabBarItem)
}

public struct TabBarEnvironment {
  public init() { }
}

public let tabBarReducer = Reducer<
  TabBarState,
  TabBarAction,
  TabBarEnvironment
>.combine([
  hotKeywordCoordinatorReducer
    .pullback(
      state: \TabBarState.hotKeyword,
      action: /TabBarAction.hotKeyword,
      environment: { _ in
        HotKeywordCoordinatorEnvironment()
      }
    ),
  mainCoordinatorReducer
    .pullback(
      state: \TabBarState.main,
      action: /TabBarAction.main,
      environment: { _ in
        MainCoordinatorEnvironment()
      }
    ),
  myPageCoordinatorReducer
    .pullback(
      state: \TabBarState.myPage,
      action: /TabBarAction.myPage,
      environment: { _ in
        MyPageCoordinatorEnvironment()
      }
    ),
  Reducer { state, action, env in
    switch action {
    case let .tabSelected(tab):
      state.selectedTab = tab
      return .none
    default: return .none
    }
  }
])
