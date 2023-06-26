//
//  MainCore.swift
//  Main
//
//  Created by 김영균 on 2023/06/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import CombineExt
import Common
import ComposableArchitecture
import Foundation
import Models
import Services

private enum Constant {
  static let defaultNewsCardWidth: CGFloat = 280
  static let defaultNewsCardHeight: CGFloat = 378
  static let iphone13MiniWidth: CGFloat = 375
  static let iphone13MiniHeight: CGFloat = 812
  static let pagingSize: Int = 10
  static let pagingCriticalPoint: Int = 5
}

public enum FetchType {
  case initial
  case continuousPaging
  case newPaging
}

public struct MainState: Equatable {
  var newsCardLayout: NewsCardLayout = .init()
  var isLoading: Bool = false
  var categories: [CategoryType] = []
  var newsCardScrollState: NewsCardScrollState?
  var cursorPage: Int = 0
  var cursorDate: Date = .now
  public init() { }
}

public enum MainAction {
  // MARK: - User Action
  case showCategoryBottomSheet([CategoryType])
  
  // MARK: - Inner Business Action
  case _viewWillAppear
  case _categoriesIsUpdated
  case _fetchCategories
  case _fetchNewsCards(FetchType)
  case _handleNewsCardsResponse([NewsCard], FetchType)
  case _cancelAllActions
  
  // MARK: - Inner SetState Action
  case _setNewsCardSize(CGSize)
  case _setIsLoading(Bool)
  case _setCategories([CategoryType])
  case _setNewsCardScrollState([NewsCard])
  
  // MARK: - Child Action
  case newsCardScroll(NewsCardScrollAction)
}

public struct MainEnvironment {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  fileprivate let newsCardService: NewsCardService
  fileprivate let categoryService: CategoryService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    newscardService: NewsCardService,
    categoryService: CategoryService
  ) {
    self.mainQueue = mainQueue
    self.newsCardService = newscardService
    self.categoryService = categoryService
  }
}

fileprivate enum CancelID: Hashable, CaseIterable {
  case _fetchCategories
  case _fetchNewsCards
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
    case ._viewWillAppear:
      return Effect.concatenate(
        Effect(value: ._fetchCategories),
        Effect(value: ._fetchNewsCards(.initial))
      )
      
    case ._categoriesIsUpdated:
      state.newsCardScrollState = nil
      state.cursorPage = 0
      state.cursorDate = .now
      return Effect.merge(
        Effect(value: ._fetchCategories),
        Effect(value: ._fetchNewsCards(.initial))
      )
      
    case ._fetchCategories:
      return env.categoryService.getAllCategories()
        .catchToEffect()
        .flatMapLatest { result -> Effect<MainAction, Never> in
          switch result {
          case let .success(categories):
            return Effect(value: ._setCategories(categories))
            
          case .failure:
            return .none
          }
        }
        .eraseToEffect()
      
    case let ._fetchNewsCards(fetchType):
      return env.newsCardService.getAllNewsCards(
        state.cursorDate,
        state.cursorPage,
        Constant.pagingSize
      )
      .catchToEffect()
      .flatMapLatest { result -> Effect<MainAction, Never> in
        switch result {
        case let .success(newsCards):
          return Effect(value: ._handleNewsCardsResponse(newsCards, fetchType))
          
        case .failure:
          return .none
        }
      }
      .eraseToEffect()
      
    case let ._handleNewsCardsResponse(newsCards, fetchType):
      return handleNewsCardsResponse(&state, source: newsCards, fetchType: fetchType)
      
    case ._cancelAllActions:
      return .cancel(ids: CancelID.allCases)
      
    case let ._setNewsCardSize(screenSize):
      state.newsCardLayout = buildNewsCardLayout(screenSize: screenSize)
      return .none
      
    case let ._setIsLoading(isLoading):
      state.isLoading = isLoading
      return .none
      
    case let ._setCategories(categories):
      state.categories = categories
      return .none
      
    case let ._setNewsCardScrollState(newsCards):
      state.newsCardScrollState = NewsCardScrollState(
        layout: state.newsCardLayout,
        newsCards: IdentifiedArray(
          uniqueElements: newsCards.enumerated().map{ index, newscard in
            NewsCardState(
              index: index,
              newsCard: newscard,
              layout: state.newsCardLayout,
              isFolded: true
            )
          }
        )
      )
      return .none
      
    case let .newsCardScroll(._fetchNewsCardsIfNeeded(currentScrollIndex, newsCardsCount)):
      if newsCardsCount - currentScrollIndex > Constant.pagingCriticalPoint { return .none }
      state.cursorPage += 1
      return Effect(value: ._fetchNewsCards(.continuousPaging))
      
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

private func handleNewsCardsResponse(
  _ state: inout MainState,
  source newsCards: [NewsCard],
  fetchType: FetchType
) -> Effect<MainAction, Never> {
  switch fetchType {
  case .initial:
    if newsCards.isEmpty {
      return .none
    }
    if state.newsCardScrollState == nil {
      return Effect(value: ._setNewsCardScrollState(newsCards))
    }
    
  case .continuousPaging:
    if newsCards.isEmpty {
      state.cursorDate = subtractOneDay(from: state.cursorDate)
      state.cursorPage = 0
      return Effect(value: ._fetchNewsCards(.newPaging))
    } else {
      return Effect(value: .newsCardScroll(._concatenateNewsCards(newsCards)))
    }
    
  case .newPaging:
    if !newsCards.isEmpty {
      return Effect(value: .newsCardScroll(._concatenateNewsCards(newsCards)))
    }
  }
  
  return .none
}

private func subtractOneDay(from date: Date) -> Date {
  let calendar = Calendar.current
  let modifiedDate = calendar.date(byAdding: .day, value: -1, to: date)
  return modifiedDate ?? date
}
