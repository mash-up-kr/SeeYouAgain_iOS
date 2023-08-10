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
import Models
import MyPageCoordinator
import Services

public struct TabBarState: Equatable {
  public var hotKeyword: HotKeywordCoordinatorState
  public var main: MainCoordinatorState
  public var myPage: MyPageCoordinatorState
  public var categoryBottomSheet: CategoryBottomSheetState
  public var selectedTab: TabBarItem = .house
  public var isTabHidden: Bool = false
  public var infoToastMessage: String?
  public var warningToastMessage: String?
  
  // 업적 바텀시트에 보여줄 업적 정보
  public var selectedAchievement: Achievement = .init(type: .firstAllReadShorts, isAchieved: false) // 초기 임시데이터
  public var achievementBottomSheetIsPresented: Bool = false
  
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
  case _presentInfoToast(String)
  case _presentWarningToast(String)
  case _hideToast
  
  // MARK: - Inner SetState Action
  case _setTabHiddenStatus(Bool)
  case _setInfoToastMessage(String?)
  case _setWarningToastMessage(String?)
  case _setAchievementBottomSheetIsPresented(Bool)
  
  // MARK: - Child Action
  case hotKeyword(HotKeywordCoordinatorAction)
  case main(MainCoordinatorAction)
  case myPage(MyPageCoordinatorAction)
  case categoryBottomSheet(CategoryBottomSheetAction)
}

public struct TabBarEnvironment {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  fileprivate let userDefaultsService: UserDefaultsService
  let appVersionService: AppVersionService
  fileprivate let newsCardService: NewsCardService
  fileprivate let categoryService: CategoryService
  fileprivate let hotKeywordService: HotKeywordService
  fileprivate let myPageService: MyPageService
  fileprivate let logService: LogService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService,
    appVersionService: AppVersionService,
    newsCardService: NewsCardService,
    categoryService: CategoryService,
    hotKeywordService: HotKeywordService,
    myPageService: MyPageService,
    logService: LogService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
    self.appVersionService = appVersionService
    self.newsCardService = newsCardService
    self.categoryService = categoryService
    self.hotKeywordService = hotKeywordService
    self.myPageService = myPageService
    self.logService = logService
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
          myPageService: $0.myPageService,
          logService: $0.logService
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
      if tab == .hotKeyword {
        return Effect(value: .hotKeyword(.routeAction(0, action: .hotKeyword(.hotkeywordTabTapped))))
      } else if tab == .myPage {
        return .concatenate(
          Effect(value: .myPage(.routeAction(0, action: .myPage(._onAppear)))),
          Effect(value: .hotKeyword(.routeAction(0, action: .hotKeyword(.otherTabsTapped))))
        )
      } else {
        return Effect(value: .hotKeyword(.routeAction(0, action: .hotKeyword(.otherTabsTapped))))
      }
      
    case let ._presentInfoToast(toastMessage):
      return .concatenate(
        Effect.cancel(id: TabBarID._presentToast),
        Effect(value: ._setInfoToastMessage(toastMessage)),
        Effect.cancel(id: TabBarID._presentToast),
        Effect(value: ._hideToast)
          .delay(for: 2, scheduler: env.mainQueue)
          .eraseToEffect()
          .cancellable(id: TabBarID._presentToast, cancelInFlight: true)
      )
      
    case let ._presentWarningToast(toastMessage):
      return .concatenate(
        Effect(value: ._setWarningToastMessage(toastMessage)),
        Effect.cancel(id: TabBarID._presentToast),
        Effect(value: ._hideToast)
          .delay(for: 2, scheduler: env.mainQueue)
          .eraseToEffect()
          .cancellable(id: TabBarID._presentToast, cancelInFlight: true)
      )
      
    case ._hideToast:
      return Effect.merge(
        Effect(value: ._setInfoToastMessage(nil)),
        Effect(value: ._setWarningToastMessage(nil))
      )
    
    case ._setTabHiddenStatus(let status):
      state.isTabHidden = status
      return .none
      
    case let ._setInfoToastMessage(message):
      state.infoToastMessage = message
      return .none
      
    case let ._setWarningToastMessage(message):
      state.warningToastMessage = message
      return .none
      
    case let ._setAchievementBottomSheetIsPresented(isPresented):
      state.achievementBottomSheetIsPresented = isPresented
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
        return Effect(value: ._presentInfoToast("뉴스 키워드가 저장됐어요:)"))
        
      case let .failure(error):
        return presentToast(on: error)
      }
    
    // 마이페이지: 업적을 탭하여 바텀시트를 띄우는 액션
    case let .myPage(
      .routeAction(_, action: .myPage(
        .myAchievementsAction(._presentAchievementBottomSheet(achievement))
      ))
    ):
      state.selectedAchievement = achievement
      state.achievementBottomSheetIsPresented = true
      return .none
      
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
            action: .shortStorageNewsList(._viewWillAppear)
          )
        )
      )
    ):
      return Effect(value: ._setTabHiddenStatus(true))
      
    case .myPage(
      .routeAction(
        _,
        action: .longStorage(
          .routeAction(
            _,
            action: .longStorageNewsList(._viewWillAppear)
          )
        )
      )
    ):
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
        action: .shortStorage(
          .routeAction(
            _,
            action: .shortStorageNewsList(._onDisappear)
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
      
    case .myPage(
      .routeAction(
        _,
        action: .longStorage(
          .routeAction(
            _,
            action: .longStorageNewsList(._onDisappear)
          )
        )
      )
    ):
      return Effect(value: ._setTabHiddenStatus(false))
      
    case .categoryBottomSheet(._categoriesIsUpdated):
      return Effect(value: .main(.routeAction(0, action: .main(._categoriesIsUpdated))))
      
    default: return .none
    }
  }
])

private func presentToast(on error: Error) -> Effect<TabBarAction, Never> {
  guard let providerError = error.toProviderError() else { return .none }
  switch providerError.code {
  case .failedRequest:
    return Effect(value: ._presentWarningToast("인터넷이 불안정해서 저장되지 못했어요."))
  
  case .isNotSuccessful:
    return Effect(value: ._presentWarningToast("이미 저장한 뉴스에요."))
    
  case .failedDecode:
    return Effect(value: ._presentWarningToast("저장에 실패했어요."))
  }
}
