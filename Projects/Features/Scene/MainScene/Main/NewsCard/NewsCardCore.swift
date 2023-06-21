//
//  NewsCardCore.swift
//  Main
//
//  Created by 김영균 on 2023/06/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Models

public struct NewsCardState: Equatable, Identifiable {
  public var index: Int
  var newsCard: NewsCard
  var layout: NewsCardLayout
  var isFolded: Bool
  
  public var id: Int { self.index }
}

public enum NewsCardAction {
  case _setIsFolded(Bool)
  
}

public struct NewsCardEnvironment {
  
}

public let newsCardReducer = Reducer<
  NewsCardState,
  NewsCardAction,
  NewsCardEnvironment
> { state, action, environment in
  switch action {
  case let ._setIsFolded(folded):
    state.isFolded = folded
    return .none
  }
}
