//
//  TabBarCore.swift
//  TabBar
//
//  Created by 안상희 on 2023/05/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import HotKeywordCoordinator
import Main
import MainCoordinator
import MyPageCoordinator

public enum Tab: Hashable {
  case hotKeyword
  case main
  case myPage
}

public struct TabBarState: Equatable {
  public var hotKeyword: HotKeywordCoordinatorState
  public var main: MainCoordinatorState
  public var myPage: MyPageCoordinatorState
  public var bottomSheet: BottomSheetState
  public var selectedTab: Tab = .main
  
  public init(
    hotKeyword: HotKeywordCoordinatorState,
    main: MainCoordinatorState,
    myPage: MyPageCoordinatorState,
    bottomSheet: BottomSheetState
  ) {
    self.hotKeyword = hotKeyword
    self.main = main
    self.myPage = myPage
    self.bottomSheet = bottomSheet
  }
}

public enum TabBarAction {
  case hotKeyword(HotKeywordCoordinatorAction)
  case main(MainCoordinatorAction)
  case myPage(MyPageCoordinatorAction)
  case bottomSheet(BottomSheetAction)
  case tabSelected(Tab)
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
  bottomSheetReducer
    .pullback(
      state: \TabBarState.bottomSheet,
      action: /TabBarAction.bottomSheet,
      environment: { _ in
        BottomSheetEnvironment()
      }
    ),
  Reducer { state, action, env in
    switch action {
    case let .tabSelected(tab):
      state.selectedTab = tab
      return .none
      
    case let .main(.routeAction(_, action: .main(.openBottomSheet(category)))):
      state.bottomSheet.categories = category
      state.bottomSheet.categoryBottomSheetIsPresented = true
      return .none
      
    case .bottomSheet(.closeCategoryBottomSheet):
      state.bottomSheet.categoryBottomSheetIsPresented = false
      let category = state.bottomSheet.categories
      return Effect(
        value: .main(.routeAction(0, action: .main(.updateCategories(category))))
      )
      
    default: return .none
    }
  }
])
