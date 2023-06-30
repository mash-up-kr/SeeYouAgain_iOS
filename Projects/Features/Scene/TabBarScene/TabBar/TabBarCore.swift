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
import MainCoordinator
import MyPageCoordinator
import Services

public struct TabBarState: Equatable {
  public var hotKeyword: HotKeywordCoordinatorState
  public var main: MainCoordinatorState
  public var myPage: MyPageCoordinatorState
  public var categoryBottomSheet: BottomSheetState
  public var selectedTab: TabBarItem = .house
  public var isTabHidden: Bool = false
  public var toastMessage: String?
  
  public init(
    hotKeyword: HotKeywordCoordinatorState,
    main: MainCoordinatorState,
    myPage: MyPageCoordinatorState,
    categoryBottomSheet: BottomSheetState,
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
  case _presentToast(String)
  case _hideToast
  
  // MARK: - Inner SetState Action
  case _setTabHiddenStatus(Bool)
  case _setToastMessage(String?)
  
  // MARK: - Child Action
  case hotKeyword(HotKeywordCoordinatorAction)
  case main(MainCoordinatorAction)
  case myPage(MyPageCoordinatorAction)
  case categoryBottomSheet(BottomSheetAction)
}

public struct TabBarEnvironment {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  fileprivate let userDefaultsService: UserDefaultsService
  let appVersionService: AppVersionService
  fileprivate let newsCardService: NewsCardService
  fileprivate let categoryService: CategoryService
  fileprivate let hotKeywordService: HotKeywordService
  fileprivate let myPageService: MyPageService
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService,
    appVersionService: AppVersionService,
    newsCardService: NewsCardService,
    categoryService: CategoryService,
    hotKeywordService: HotKeywordService,
    myPageService: MyPageService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
    self.appVersionService = appVersionService
    self.newsCardService = newsCardService
    self.categoryService = categoryService
    self.hotKeywordService = hotKeywordService
    self.myPageService = myPageService
  }
}

enum TabBarID: Hashable {
  case _presentToast
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
      environment: {
        HotKeywordCoordinatorEnvironment(
          mainQueue: $0.mainQueue,
          hotKeywordService: $0.hotKeywordService
        )
      }
    ),
  mainCoordinatorReducer
    .pullback(
      state: \TabBarState.main,
      action: /TabBarAction.main,
      environment: {
        MainCoordinatorEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: $0.userDefaultsService,
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
          appVersionService: $0.appVersionService,
          myPageService: $0.myPageService
        )
      }
    ),
  bottomSheetReducer
    .pullback(
      state: \TabBarState.categoryBottomSheet,
      action: /TabBarAction.categoryBottomSheet,
      environment: {
        BottomSheetEnvironment(
          mainQueue: $0.mainQueue,
          categoryService: $0.categoryService
        )
      }
    ),
  Reducer { state, action, env in
    switch action {
    case let .tabSelected(tab):
      state.selectedTab = tab
      if tab == .hotKeyword {
        return Effect(value: .hotKeyword(.routeAction(0, action: .hotKeyword(._viewWillAppear))))
      }
      return .none
      
    case let ._presentToast(toastMessage):
      return .concatenate(
        Effect(value: ._setToastMessage(toastMessage)),
        Effect.cancel(id: TabBarID._presentToast),
        Effect(value: ._hideToast)
          .delay(for: 2, scheduler: env.mainQueue)
          .eraseToEffect()
          .cancellable(id: TabBarID._presentToast, cancelInFlight: true)
      )
      
    case ._hideToast:
      return Effect(value: ._setToastMessage(nil))
    
    case ._setTabHiddenStatus(let status):
      state.isTabHidden = status
      return .none
      
    case let ._setToastMessage(message):
      state.toastMessage = message
      return .none
      
    case let .main(.routeAction(_, action: .main(.showCategoryBottomSheet(categories)))):
      return Effect.concatenate(
        Effect(value: .categoryBottomSheet(._setSelectedCategories(categories))),
        Effect(value: .categoryBottomSheet(._setIsPresented(true)))
      )
      
    case let .main(
      .routeAction(
        _, action: .main(
          .newsCardScroll(
            .newsCard(
              id: _,
              action: ._handleSaveNewsCardResponse(response)
            )
          )
        )
      )
    ):
      switch response {
      case .success:
        return Effect(value: ._presentToast("오늘 읽을 숏스에 저장됐어요:)"))
        
      case .failure:
        return Effect(value: ._presentToast("인터넷이 불안정해서 저장되지 못했어요."))
      }
      
    // 메인: 뉴스 카드를 선택하여 뉴스 리스트로 이동할 때 
    case .main(.routeAction(_, action: .main(.newsCardScroll(.newsCard(id: _, action: ._navigateNewsList))))):
      return Effect(value: ._setTabHiddenStatus(true))
      
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
      return Effect(value: .main(.routeAction(0, action: .main(._categoriesIsUpdated))))
      
    default: return .none
    }
  }
])
