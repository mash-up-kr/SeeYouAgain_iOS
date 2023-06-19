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

public struct TabBarState: Equatable {
  public var hotKeyword: HotKeywordCoordinatorState
  public var main: MainCoordinatorState
  public var myPage: MyPageCoordinatorState
  public var categoryBottomSheet: CategoryBottomSheetState
  public var selectedTab: TabBarItem = .house
  public var isTabHidden: Bool = false
  
  public init(
    hotKeyword: HotKeywordCoordinatorState,
    main: MainCoordinatorState,
    myPage: MyPageCoordinatorState,
    categoryBottomSheet: CategoryBottomSheetState,
    isTabHidden: Bool
  ) {
    self.hotKeyword = hotKeyword
    self.main = main
    self.myPage = myPage
    self.categoryBottomSheet = categoryBottomSheet
    self.isTabHidden = isTabHidden
  }
}

public enum TabBarAction {
  // MARK: - User Action
  case tabSelected(TabBarItem)
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  case _setTabHiddenStatus(Bool)
  
  // MARK: - Child Action
  case hotKeyword(HotKeywordCoordinatorAction)
  case main(MainCoordinatorAction)
  case myPage(MyPageCoordinatorAction)
  case categoryBottomSheet(CategoryBottomSheetAction)
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
      
    case ._setTabHiddenStatus(let status):
      state.isTabHidden = status
      return .none
      
    case .myPage(.routeAction(_, action: .myPage(.settingButtonTapped))):
      return Effect(value: ._setTabHiddenStatus(true))
      
    case .myPage(.routeAction(_, action: .myPage(.info(.shortsAction(.shortShortsButtonTapped))))):
      return Effect(value: ._setTabHiddenStatus(true))
      
    case .myPage(.routeAction(_, action: .myPage(.info(.shortsAction(.longShortsButtonTapped))))):
      return Effect(value: ._setTabHiddenStatus(true))
      
    case .myPage(.routeAction(_, action: .shortStorage(.routeAction(_, action: .shortStorageNewsList(.backButtonTapped))))):
      return Effect(value: ._setTabHiddenStatus(false))
      
    case .myPage(.routeAction(_, action: .longStorage(.routeAction(_, action: .longStorageNewsList(.backButtonTapped))))):
      return Effect(value: ._setTabHiddenStatus(false))
      
    case .myPage(.routeAction(_, action: .setting(.routeAction(_, action: .setting(.backButtonTapped))))):
      return Effect(value: ._setTabHiddenStatus(false))

    default: return .none
    }
  }
])
