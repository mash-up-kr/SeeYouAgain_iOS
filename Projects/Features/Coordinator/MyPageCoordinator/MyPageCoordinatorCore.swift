//
//  MyPageCoordinatorCore.swift
//  MyPageCoordinator
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import MyPage
import TCACoordinators

public struct MyPageCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<MyPageScreenState>]
  
  public init(
    routes: [Route<MyPageScreenState>] = [
      .root(
        .myPage(
          .init(
            info: .init(
              info: .init(
                nickname: "똑똑한여행가",
                day: 1004
              ),
              shorts: .init(
                shorts: MyShorts(
                  totalShortsCount: 56,
                  shortShortsCount: 5,
                  longShortsCount: 56
                )
              )
            )
          )
        ),
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
  public init() {}
}

public let myPageCoordinatorReducer: Reducer<
  MyPageCoordinatorState,
  MyPageCoordinatorAction,
  MyPageCoordinatorEnvironment
> = myPageScreenReducer
  .forEachIndexedRoute(
    environment: { _ in
      MyPageScreenEnvironment()
    }
  )
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      case .routeAction(_, action: .myPage(.settingButtonTapped)):
        state.routes.push(.setting(.init()))
        return .none
        
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
        
      case .routeAction(_, action: .setting(.routeAction(_, action: .setting(.backButtonTapped)))):
        state.routes.pop()
        return .none
        
      default: return .none
      }
    }
  )
