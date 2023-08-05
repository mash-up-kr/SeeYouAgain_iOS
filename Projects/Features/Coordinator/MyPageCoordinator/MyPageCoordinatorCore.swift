//
//  MyPageCoordinatorCore.swift
//  MyPageCoordinator
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import Models
import MyPage
import Services
import TCACoordinators

public struct MyPageCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<MyPageScreenState>]
  
  public init(
    routes: [Route<MyPageScreenState>] = [
      .root(
        .myPage(.init()),
        embedInNavigationView: true
      )
    ]
  ) {
    self.routes = routes
  }
}

public enum MyPageCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<MyPageScreenState>])
  case routeAction(Int, action: MyPageScreenAction)
}

public struct MyPageCoordinatorEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let appVersionService: AppVersionService
  let myPageService: MyPageService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    appVersionService: AppVersionService,
    myPageService: MyPageService
  ) {
    self.mainQueue = mainQueue
    self.appVersionService = appVersionService
    self.myPageService = myPageService
  }
}

public let myPageCoordinatorReducer: Reducer<
  MyPageCoordinatorState,
  MyPageCoordinatorAction,
  MyPageCoordinatorEnvironment
> = myPageScreenReducer
  .forEachIndexedRoute(
    environment: {
      MyPageScreenEnvironment(
        mainQueue: $0.mainQueue,
        appVersionService: $0.appVersionService,
        myPageService: $0.myPageService
      )
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      case .routeAction(_, action: .myPage(.info(.shortsAction(.shortShortsButtonTapped)))):
        state.routes.push(.shortStorage(.init()))
        return .none
        
      case .routeAction(_, action: .myPage(.info(.shortsAction(.longShortsButtonTapped)))):
        state.routes.push(.longStorage(.init()))
        return .none
        
      case .routeAction(_, action: .shortStorage(.routeAction(_, action: .shortStorageNewsList(.backButtonTapped)))):
        state.routes.pop()
        return .none
        
      case .routeAction(_, action: .longStorage(.routeAction(_, action: .longStorageNewsList(.backButtonTapped)))):
        state.routes.pop()
        return .none
        
      case let .routeAction(_, action: .myPage(.myAchievementsAction(.achievementBadgeTapped(badge)))):
        state.routes.presentCover(.achievementShare(.init(achievementType: badge)), embedInNavigationView: true)
        return .none
        
      case .routeAction(_, action: .achievementShare(.dismissButtonDidTapped)):
        state.routes.dismiss()
        return .none
        
      default: return .none
      }
    }
  )
