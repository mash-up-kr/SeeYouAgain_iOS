//
//  AppCoordinatorCore.swift
//  CoordinatorKit
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import Services
import Splash
import TCACoordinators

public struct AppCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<AppScreenState>]
  
  public init(routes: [Route<AppScreenState>] = [.root(.splash(.init()), embedInNavigationView: true)]) {
    self.routes = routes
  }
}

public enum AppCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<AppScreenState>])
  case routeAction(Int, action: AppScreenAction)
}

public struct AppCoordinatorEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let userDefaultsService: UserDefaultsService
  let appVersionService: AppVersionService
  let newsCardService: NewsCardService
  let categoryService: CategoryService
  let hotKeywordService: HotKeywordService
  let myPageService: MyPageService
  let logService: LogService
  
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

public let appCoordinatorReducer: Reducer<
  AppCoordinatorState,
  AppCoordinatorAction,
  AppCoordinatorEnvironment
> = appScreenReducer
  .forEachIndexedRoute(
    environment: {
      AppScreenEnvironment(
        mainQueue: $0.mainQueue,
        userDefaultsService: $0.userDefaultsService,
        appVersionService: $0.appVersionService,
        newsCardService: $0.newsCardService,
        categoryService: $0.categoryService,
        hotKeywordService: $0.hotKeywordService,
        myPageService: $0.myPageService,
        logService: $0.logService
      )
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      case .routeAction(_, action: .splash(._moveToHome)):
        state.routes = [
          .root(
            .tabBar(
              .init(
                hotKeyword: .init(),
                main: .init(),
                myPage: .init(),
                categoryBottomSheet: .init(),
                isTabHidden: false
              )
            ),
            embedInNavigationView: true
          )
        ]
        return .none
        
      case .routeAction(_, action: .splash(._moveToSetCategory)):
        state.routes = [
          .root(
            .setCategory(.init()),
            embedInNavigationView: true
          )
        ]
        return .none
        
      case .routeAction(_, action: .setCategory(._saveUserID)):
        state.routes = [
          .root(
            .tabBar(
              .init(
                hotKeyword: .init(),
                main: .init(),
                myPage: .init(),
                categoryBottomSheet: .init(),
                isTabHidden: false
              )
            ),
            embedInNavigationView: true
          )
        ]
        return .none
      
      case let .routeAction(
        _, action: .tabBar(
          .myPage(
            .routeAction(
              _, action: .myPage(.settingButtonTapped(nickname))
            )
          )
        )
      ):
        state.routes.push(.setting(.init(nickname: nickname)))
        return .none
        
      case .routeAction(_, action: .setting(.routeAction(_, action: .setting(.backButtonTapped)))):
        state.routes.goBack()
        return .none
        
      case .routeAction(_, action: .setting(.routeAction(_, action: .modeSelection(.navigateHome)))),
        .routeAction(_, action: .setting(.routeAction(_, action: .companySelection(.companySelectCompleted)))):
        state.routes.goBackToRoot()
        return .none
        
      case let .routeAction(
        _, action: .tabBar(
          .main(
            .routeAction(
              _, action: .main(
                .newsCardScroll(
                  .newsCard(id: _, action: ._navigateNewsList(id, keyword))
                )
              )
            )
          )
        )
      ):
        state.routes.push(.newsCard(.init(source: .main, shortsId: id, keywordTitle: keyword)))
        return .none
        
      case let .routeAction(
        _, action: .tabBar(
          .hotKeyword(
            .routeAction(
              _, action: .hotKeyword(
                .showKeywordNewsList(keyword)
              )
            )
          )
        )
      ):
        state.routes.push(.newsCard(.init(source: .hot, shortsId: 0, keywordTitle: "#\(keyword)")))
        return .none
        
      case let .routeAction(
        _,
        action: .tabBar(
          .myPage(
            .routeAction(
              _,
              action: .shortStorage(
                .routeAction(
                  _,
                  action: .shortStorageNewsList(
                    .shortsNewsItem(
                      id: id,
                      action: .cardAction(._navigateNewsList(keyword))
                    )
                  )
                )
              )
            )
          )
        )
      ):
        state.routes.push(.newsCard(.init(source: .shortStorage, shortsId: id, keywordTitle: keyword)))
        return .none
        
      case let .routeAction(
        _,
        action: .tabBar(
          .myPage(
            .routeAction(
              _,
              action: .longStorage(
                .routeAction(
                  _,
                  action: .longStorageNewsList(
                    .shortsNewsItem(
                      id: id,
                      action: .cardAction(._navigateNewsList(url))
                    )
                  )
                )
              )
            )
          )
        )
      ):
        state.routes.push(.newsCard(.init(source: .longStorage, newsId: id, webAddress: url)))
        return .none
        
      case let .routeAction(_, action: .newsCard(.routeAction(_, action: .web(.backButtonTapped(source))))):
        if source == .longStorage {
          state.routes.pop()
        }
        return .none
        
      case .routeAction(_, action: .newsCard(.routeAction(_, action: .shortsComplete(.backButtonTapped)))):
        state.routes.pop()
        return tapShortStorageNewsListBackButton(action: action)
        
      case .routeAction(_, action: .newsCard(.routeAction(_, action: .shortsComplete(.confirmButtonTapped)))):
        state.routes.pop()
        return tapShortStorageNewsListBackButton(action: action)
        
      case let .routeAction(_, action: .newsCard(.routeAction(_, action: .newsList(.backButtonTapped(source))))):
        state.routes.pop()
        switch source {
        case .main, .hot:
          return Effect(value: .routeAction(0, action: .tabBar(._setTabHiddenStatus(false))))
          
        case .shortStorage, .longStorage:
          return .none
        }
        
      case let .routeAction(_, action: .newsCard(.routeAction(_, action: .newsList(._onDisappear(source))))):
        switch source {
        case .main, .hot:
          return Effect(value: .routeAction(0, action: .tabBar(._setTabHiddenStatus(false))))
          
        case .shortStorage, .longStorage:
          return .none
        }
        
      default: return .none
      }
    }
  )

fileprivate func tapShortStorageNewsListBackButton(
  action: AppCoordinatorAction
) -> Effect<AppCoordinatorAction, Never> {
  return Effect(
    value: .routeAction(0, action: .tabBar(
      .myPage(.routeAction(0, action:
        .shortStorage(.routeAction(0, action:
          .shortStorageNewsList(.backButtonTapped)
        ))
      ))
    ))
  )
}
