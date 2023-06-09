//
//  HotKeywordCoordinatorCore.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import HotKeyword
import Services
import SwiftUI
import TCACoordinators

public struct HotKeywordCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<HotKeywordScreenState>]
  
  public init(
    routes: [Route<HotKeywordScreenState>] = [
      .root(
        .hotKeyword(.init()),
        embedInNavigationView: true
      )
    ]
  ) {
    self.routes = routes
  }
}

public enum HotKeywordCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<HotKeywordScreenState>])
  case routeAction(Int, action: HotKeywordScreenAction)
}

public struct HotKeywordCoordinatorEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let hotKeywordService: HotKeywordService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    hotKeywordService: HotKeywordService
  ) {
    self.mainQueue = mainQueue
    self.hotKeywordService = hotKeywordService
  }
}

public let hotKeywordCoordinatorReducer: Reducer<
  HotKeywordCoordinatorState,
  HotKeywordCoordinatorAction,
  HotKeywordCoordinatorEnvironment
> = hotKeywordScreenReducer
  .forEachIndexedRoute(environment: {
    HotKeywordScreenEnvironment(
      mainQueue: $0.mainQueue,
      hotKeywordService: $0.hotKeywordService
    )
  })
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      default: return .none
      }
    }
  )
