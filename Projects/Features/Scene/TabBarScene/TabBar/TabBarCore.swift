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
  public var categoryBottomSheet: CategoryBottomSheetState
  public var selectedTab: Tab = .main
  
  public init(
    hotKeyword: HotKeywordCoordinatorState,
    main: MainCoordinatorState,
    myPage: MyPageCoordinatorState,
    categoryBottomSheet: CategoryBottomSheetState
  ) {
    self.hotKeyword = hotKeyword
    self.main = main
    self.myPage = myPage
    self.categoryBottomSheet = categoryBottomSheet
  }
}

public enum TabBarAction {
  case hotKeyword(HotKeywordCoordinatorAction)
  case main(MainCoordinatorAction)
  case myPage(MyPageCoordinatorAction)
  case categoryBottomSheet(CategoryBottomSheetAction)
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
  categoryBottomSheetReducer
    .pullback(
      state: \TabBarState.categoryBottomSheet,
      action: /TabBarAction.categoryBottomSheet,
      environment: { _ in
        CategoryBottomSheetEnvironment()
      }
    ),
  Reducer { state, action, env in
    switch action {
    case let .tabSelected(tab):
      state.selectedTab = tab
      return .none
      
    case let .main(.routeAction(_, action: .main(.showCategoryBottomSheet(categories)))):
      return Effect.concatenate(
        Effect(value: .categoryBottomSheet(._setCategories(categories))),
        Effect(value: .categoryBottomSheet(._setIsPresented(true)))
      )
      
    case .categoryBottomSheet(.updateButtonTapped):
      let categories = state.categoryBottomSheet.categories
      return Effect.concatenate(
        Effect(value: .categoryBottomSheet(._setIsPresented(false))),
        Effect(value: .main(.routeAction(0, action: .main(._setCategories(categories)))))
      )
      
    default: return .none
    }
  }
])
