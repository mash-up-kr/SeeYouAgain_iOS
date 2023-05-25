//
//  TabBarCoordinatorCore.swift
//  Coordinator
//
//  Created by 안상희 on 2023/05/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import HotKeywordCoordinator
import MainCoordinator
import MyPageCoordinator

public enum Tab: Hashable {
  case hotKeyword
  case main
  case myPage
}

public struct TabBarCoordinatorState: Equatable {
  public var hotKeyword: HotKeywordCoordinatorState
  public var main: MainCoordinatorState
  public var myPage: MyPageCoordinatorState
  public var selectedTab: Tab = .main
  
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

public enum TabBarCoordinatorAction {
  case hotKeyword(HotKeywordCoordinatorAction)
  case main(MainCoordinatorAction)
  case myPage(MyPageCoordinatorAction)
  case tabSelected(Tab)
}

public struct TabBarCoordinatorEnvironment {
  public init() { }
}

public let tabBarCoordinatorReducer = Reducer<
  TabBarCoordinatorState,
  TabBarCoordinatorAction,
  TabBarCoordinatorEnvironment
>.combine([
  hotKeywordCoordinatorReducer
    .pullback(
      state: \TabBarCoordinatorState.hotKeyword,
      action: /TabBarCoordinatorAction.hotKeyword,
      environment: { _ in
        HotKeywordCoordinatorEnvironment()
      }
    ),
  mainCoordinatorReducer
    .pullback(
      state: \TabBarCoordinatorState.main,
      action: /TabBarCoordinatorAction.main,
      environment: { _ in
        MainCoordinatorEnvironment()
      }
    ),
  myPageCoordinatorReducer
    .pullback(
      state: \TabBarCoordinatorState.myPage,
      action: /TabBarCoordinatorAction.myPage,
      environment: { _ in
        MyPageCoordinatorEnvironment()
      }
    )
])
