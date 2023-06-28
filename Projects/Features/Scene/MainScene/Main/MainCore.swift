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
  var fetchIds: Set<FetchID> = []
  var newsCardLayout: NewsCardLayout = .init()
  
  var categories: [CategoryType] = []
  var newsCardScrollState: NewsCardScrollState?
  var cursorPage: Int = 0
  var cursorDate: Date = .now
  var saveGuideState: SaveGuideState?
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
  
  // MARK: - Inner SetState Action
  case _initialize
  case _setNewsCardSize(CGSize)
  case _setCategories(Result<[CategoryType], Error>)
  case _setNewsCards(Result<[NewsCard], Error>, FetchType)
  case _setNewsCardScrollState([NewsCard])
  case _setSaveGuideState(SaveGuideState?)
  
  // MARK: - Child Action
  case newsCardScroll(NewsCardScrollAction)
  case saveGuide(SaveGuideAction)
}

public struct MainEnvironment {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue>
  fileprivate let userDefaultsService: UserDefaultsService
  fileprivate let newsCardService: NewsCardService
  fileprivate let categoryService: CategoryService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService,
    newscardService: NewsCardService,
    categoryService: CategoryService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
    self.newsCardService = newscardService
    self.categoryService = categoryService
  }
}

enum FetchID: Hashable, CaseIterable {
  case _fetchCategories
  case _fetchNewsCards
}

public let mainReducer = Reducer.combine([
  newsCardScrollReducer
    .optional()
    .pullback(
      state: \.newsCardScrollState,
      action: /MainAction.newsCardScroll,
      environment: { NewsCardScrollEnvironmnet(newsCardService: $0.newsCardService) }
    ),
  saveGuideReducer
    .optional()
    .pullback(
      state: \.saveGuideState,
      action: /MainAction.saveGuide,
      environment: {
        SaveGuideEnvironment(
          mainQueue: $0.mainQueue,
          userDefaultsService: $0.userDefaultsService
        )
      }
    ),
  Reducer<MainState, MainAction, MainEnvironment> { state, action, env in
    switch action {
    case ._viewWillAppear:
      FetchID.allCases.forEach { state.fetchIds.insert($0) }
      return Effect.merge(
        Effect(value: ._fetchCategories),
        Effect(value: ._fetchNewsCards(.initial))
      )
      
    case ._categoriesIsUpdated:
      return Effect.concatenate(
        Effect(value: ._initialize),
        Effect(value: ._viewWillAppear)
          .delay(for: .milliseconds(500), scheduler: env.mainQueue)
          .eraseToEffect()
      )
      
      
    case ._fetchCategories:
      return env.categoryService.getAllCategories()
        .catchToEffect()
        .map(MainAction._setCategories)
        .eraseToEffect()
      
    case let ._fetchNewsCards(fetchType):
      return env.newsCardService.getAllNewsCards(
        state.cursorDate,
        state.cursorPage,
        Constant.pagingSize
      )
      .catchToEffect()
      .map { MainAction._setNewsCards($0, fetchType) }
      .eraseToEffect()
      
    case ._initialize:
      state.fetchIds = []
      state.categories = []
      state.newsCardScrollState = nil
      state.cursorPage = 0
      state.cursorDate = .now
      state.saveGuideState = nil
      return .none
    
    case let ._setNewsCardSize(screenSize):
      state.newsCardLayout = buildNewsCardLayout(screenSize: screenSize)
      return .none
      
    case let ._setCategories(result):
      state.fetchIds.remove(FetchID._fetchCategories)
      switch result {
      case let .success(categories):
        state.categories = categories
        return .none
        
      case .failure:
        return .none
      }
      
    case let ._setNewsCards(result, fetchType):
      state.fetchIds.remove(FetchID._fetchNewsCards)
      switch result {
      case let .success(newsCards):
        return handleNewsCardsResponse(&state, source: newsCards, fetchType: fetchType)
      
      case .failure:
        return .none
      }
    
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
      
    case let ._setSaveGuideState(saveGuideState):
      state.saveGuideState = saveGuideState
      return .none
      
    case let .newsCardScroll(._fetchNewsCardsIfNeeded(currentScrollIndex, newsCardsCount)):
      if newsCardsCount - currentScrollIndex > Constant.pagingCriticalPoint { return .none }
      state.cursorPage += 1
      return Effect(value: ._fetchNewsCards(.continuousPaging))
      
    case .newsCardScroll(.newsCard(id: _, action: ._saveNewsCard)):
      return Effect(value: .saveGuide(._startAnimation))
      
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
      return Effect.merge(
        Effect(value: ._setNewsCardScrollState(newsCards)),
        Effect(value: ._setSaveGuideState(.init()))
      )
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
