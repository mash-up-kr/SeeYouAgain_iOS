//
//  MainCore.swift
//  Main
//
//  Created by 김영균 on 2023/06/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation
import Models
import Services

private enum Constant {
  static let defaultNewsCardWidth: CGFloat = 280
  static let defaultNewsCardHeight: CGFloat = 378
  static let iphone13MiniWidth: CGFloat = 375
  static let iphone13MiniHeight: CGFloat = 812
}

public typealias Category = Models.Category
public struct MainState: Equatable {
  var screenSize: CGSize = .zero
  var newsCardSize: CGSize = .zero
  
  var isLoading: Bool = false
  var categories: [Category] = []
  var newsCardScrollState: NewsCardScrollState?
  public init() { }
}

public enum MainAction {
  // MARK: - User Action
  case showCategoryBottomSheet([Category])
  
  // MARK: - Inner Business Action
  case _viewWillAppear(CGSize)
  case _fetchCategories
  case _updateCategories
  case _fetchNewsCards
  case _calculateNewsCardSize
  
  // MARK: - Inner SetState Action
  case _setIsLoading(Bool)
  case _setCategories([Category])
  case _setNewsCardScrollState(NewsCardLayout)
  
  // MARK: - Child Action
  case newsCardScroll(NewsCardScrollAction)
}

public struct MainEnvironment {
  let newsCardService: NewsCardService = .live
  public init() {}
}

public let mainReducer = Reducer.combine([
  newsCardScrollReducer
    .optional()
    .pullback(
      state: \.newsCardScrollState,
      action: /MainAction.newsCardScroll,
      environment: { _ in NewsCardScrollEnvironmnet() }
    ),
  Reducer<MainState, MainAction, MainEnvironment> { state, action, env in
    switch action {
    case let ._viewWillAppear(screen):
      state.screenSize = screen
      return Effect.concatenate([
        Effect(value: ._setIsLoading(true)),
        Effect(value: ._fetchCategories),
        Effect(value: ._fetchNewsCards),
        Effect(value: ._setIsLoading(false))
      ])
      
    case ._fetchCategories:
      state.categories = Category.stub
      return .none
      
    case ._updateCategories:
      // TODO: update categories to sever
      return .none
      
    case ._fetchNewsCards:
      return Effect(value: ._calculateNewsCardSize)
      
    case ._calculateNewsCardSize:
      let newsCardLayout = buildNewsCardLayout(screenSize: state.screenSize)
      return Effect(value: ._setNewsCardScrollState(newsCardLayout))
      
    case let ._setIsLoading(isLoading):
      state.isLoading = isLoading
      return .none
      
    case let ._setCategories(categories):
      state.categories = categories
      return .none
      
    case let ._setNewsCardScrollState(newsCardLayout):
      state.newsCardSize = newsCardLayout.size
      state.newsCardScrollState = NewsCardScrollState(
        layout: buildNewsCardLayout(
          screenSize: state.screenSize
        ),
        newsCards: NewsCard.stub
      )
      return .none
      
    default:
      return .none
    }
  }
])

private func buildNewsCardLayout(screenSize: CGSize) -> NewsCardLayout {
  let deviceRatio = CGSize(
    width: screenSize.width / Constant.iphone13MiniWidth,
    height: screenSize.height / Constant.iphone13MiniHeight
  )
  let newsCardSize = CGSize(
    width: Constant.defaultNewsCardWidth * deviceRatio.width,
    height: Constant.defaultNewsCardHeight * deviceRatio.height
  )
  let newsCardSpacing = (screenSize.width - newsCardSize.width) / 5
  let leadingOffset = (screenSize.width - newsCardSize.width) / 2
  
  return NewsCardLayout(
    ratio: deviceRatio,
    size: newsCardSize,
    spacing: newsCardSpacing,
    leadingOffset: leadingOffset
  )
}
