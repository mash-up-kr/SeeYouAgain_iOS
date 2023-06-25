//
//  TabBarCore.swift
//  TabBar
//
//  Created by 안상희 on 2023/05/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation
import HotKeywordCoordinator
import Main
import MainCoordinator
import MyPageCoordinator
import Services

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
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  let appVersionService: AppVersionService
  fileprivate let newsCardService: NewsCardService
  fileprivate let categoryService: CategoryService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    appVersionService: AppVersionService,
    newsCardService: NewsCardService,
    categoryService: CategoryService
  ) {
    self.mainQueue = mainQueue
    self.appVersionService = appVersionService
    self.newsCardService = newsCardService
    self.categoryService = categoryService
  }
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
      environment: {
        MainCoordinatorEnvironment(
          mainQueue: $0.mainQueue,
          newsCardService: $0.newsCardService,
          categoryService: $0.categoryService
        )
      }
    ),
  myPageCoordinatorReducer
    .pullback(
      state: \TabBarState.myPage,
      action: /TabBarAction.myPage,
      environment: {
        MyPageCoordinatorEnvironment(
          mainQueue: $0.mainQueue,
          appVersionService: $0.appVersionService
        )
      }
    ),
  categoryBottomSheetReducer
    .pullback(
      state: \TabBarState.categoryBottomSheet,
      action: /TabBarAction.categoryBottomSheet,
      environment: {
        CategoryBottomSheetEnvironment(
          mainQueue: $0.mainQueue,
          categoryService: $0.categoryService
        )
      }
    ),
  Reducer { state, action, env in
    switch action {
    case let .tabSelected(tab):
      state.selectedTab = tab
      return .none
      
    case let .main(.routeAction(_, action: .main(.showCategoryBottomSheet(categories)))):
      return Effect.concatenate(
        Effect(value: .categoryBottomSheet(._setSelectedCategories(categories))),
        Effect(value: .categoryBottomSheet(._setIsPresented(true)))
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
      
    case .myPage(
      .routeAction(
        _,
        action: .shortStorage(
          .routeAction(
            _,
            action: .shortStorageNewsList(.backButtonTapped)
          )
        )
      )
    ):
      return Effect(value: ._setTabHiddenStatus(false))
      
    case .myPage(
      .routeAction(
        _,
        action: .longStorage(
          .routeAction(
            _,
            action: .longStorageNewsList(.backButtonTapped)
          )
        )
      )
    ):
      return Effect(value: ._setTabHiddenStatus(false))
      
    case .myPage(.routeAction(_, action: .setting(.routeAction(_, action: .setting(.backButtonTapped))))):
      return Effect(value: ._setTabHiddenStatus(false))
      
    case .categoryBottomSheet(._categoriesIsUpdated):
      return Effect(value: .main(.routeAction(0, action: .main(._viewWillAppear))))
      
    default: return .none
    }
  }
])
