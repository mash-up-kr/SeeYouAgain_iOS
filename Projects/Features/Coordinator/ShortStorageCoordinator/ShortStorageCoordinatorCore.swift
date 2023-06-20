//
//  ShortStorageCoordinatorCore.swift
//  Coordinator
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Services
import ShortStorageNewsList
import SwiftUI
import TCACoordinators

public struct ShortStorageCoordinatorState: Equatable, IndexedRouterState {
  public var routes: [Route<ShortStorageScreenState>]
  
  public init(
    routes: [Route<ShortStorageScreenState>] = [
      .root(
        .shortStorageNewsList(
          .init(
            isInEditMode: false,
            shortslistCount: 7,
            shortsClearCount: 3,
            itemState: .init(
              id: 0,
              isInEditMode: false,
              isSelected: true,
              cardState: .init(
                shortsNews: ShortsNews(id: 0, category: "#세계", keywords: "#자위대 호위함 #사카이 료 (Sakai Ryo) #이스턴 엔데버23 #부산항"),
                isCardSelectable: true
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

public enum ShortStorageCoordinatorAction: IndexedRouterAction {
  case updateRoutes([Route<ShortStorageScreenState>])
  case routeAction(Int, action: ShortStorageScreenAction)
}

public struct ShortStorageCoordinatorEnvironment {
  public init() {}
}

public let shortStorageCoordinatorReducer: Reducer<
  ShortStorageCoordinatorState,
  ShortStorageCoordinatorAction,
  ShortStorageCoordinatorEnvironment
> = shortStorageScreenReducer
  .forEachIndexedRoute(environment: { _ in
    ShortStorageScreenEnvironment()
  })
  .withRouteReducer(
    Reducer { state, action, env in
      switch action {
      default: return .none
      }
    }
  )
