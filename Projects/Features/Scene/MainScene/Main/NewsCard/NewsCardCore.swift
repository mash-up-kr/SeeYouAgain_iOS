//
//  NewsCardCore.swift
//  Main
//
//  Created by 김영균 on 2023/06/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

private enum Constant {
  static let saveScrollThreshold: CGFloat = 80
  static let saveScrollYOffset: CGFloat = 160
}

public enum ViewState: Equatable {
  case appear
  case disappear
}

public struct NewsCardState: Equatable, Identifiable {
  var index: Int
  var newsCard: NewsCard
  var layout: NewsCardLayout
  var isFolded: Bool
  var viewState: ViewState
  var yOffset: CGFloat
  var opacity: CGFloat
  public var id: Int { self.index }
  
  public init(
    index: Int,
    newsCard: NewsCard,
    layout: NewsCardLayout,
    isFolded: Bool,
    viewState: ViewState = .appear,
    yOffset: CGFloat = 0.0,
    opacity: CGFloat = 1.0
  ) {
    self.index = index
    self.newsCard = newsCard
    self.layout = layout
    self.isFolded = isFolded
    self.viewState = viewState
    self.yOffset = yOffset
    self.opacity = opacity
  }
}

public enum NewsCardAction {
  // MARK: User Action
  case dragOnChanged(CGSize)
  case dragOnEnded(CGSize)
  case newsCardTapped
  
  // MARK: - Inner Business Action
  case _navigateNewsList(Int, String)
  case _saveNewsCard
  case _handleSaveNewsCardResponse(Result<VoidResponse?, Error>)
  
  // MARK: Inner SetState Action
  case _setIsFolded(Bool)
  case _setyOffset(CGFloat)
  case _setOpacity(CGFloat)
  case _setyOffsetWithOpacity(CGFloat)
  case _setViewState(ViewState)
}

public struct NewsCardEnvironment {
  fileprivate let mainQueue: AnySchedulerOf<DispatchQueue> = .main
  fileprivate let newsCardService: NewsCardService
  
  public init(newsCardService: NewsCardService) {
    self.newsCardService = newsCardService
  }
}

public let newsCardReducer = Reducer<
  NewsCardState,
  NewsCardAction,
  NewsCardEnvironment
> { state, action, env in
  switch action {
  case let .dragOnChanged(translation):
    if translation.height < .zero { return .none }
    return Effect(value: ._setyOffsetWithOpacity(translation.height))
    
  case let .dragOnEnded(translation):
    if translation.height < Constant.saveScrollThreshold { return Effect(value: ._setyOffsetWithOpacity(.zero)) }
    return Effect(value: ._saveNewsCard)

  case .newsCardTapped:
    return Effect(value: ._navigateNewsList(state.newsCard.id, state.newsCard.hashtagString()))
    
  case ._navigateNewsList:
    return .none
    
  case ._saveNewsCard:
    return env.newsCardService.saveNewsCard(state.newsCard.id)
      .catchToEffect(NewsCardAction._handleSaveNewsCardResponse)
    
  case ._handleSaveNewsCardResponse(.success):
    return Effect.concatenate(
      // 아래로 사라지는 애니메이션
      Effect(value: ._setyOffsetWithOpacity(Constant.saveScrollYOffset)),
      // 사라진 상태로 설정한다.
      Effect(value: ._setViewState(.disappear)),
      // 사라진 상태에서 다시 원위치로 올린다.
      Effect(value: ._setIsFolded(true)),
      Effect(value: ._setyOffset(.zero)),
      // 보여진 상태로 설정한다.
      Effect(value: ._setViewState(.appear)),
      // 투명도를 1로하여 다시 보여준다.
      Effect(value: ._setOpacity(1)).delay(for: 0.6, scheduler: env.mainQueue).eraseToEffect()
    )
    
  case ._handleSaveNewsCardResponse(.failure):
    return Effect(value: ._setyOffsetWithOpacity(.zero))
    
  case let ._setIsFolded(folded):
    state.isFolded = folded
    return .none
    
  case let ._setyOffset(yOffset):
    state.yOffset = yOffset
    return .none
    
  case let ._setOpacity(opacity):
    state.opacity = opacity
    return .none
    
  case let ._setyOffsetWithOpacity(value):
    state.yOffset = value
    switch state.viewState {
    case .appear:
      state.opacity = calculateOpacity(by: value)
      
    case .disappear:
      state.opacity = 0
    }
    return .none
    
  case let ._setViewState(viewState):
    state.viewState = viewState
    return .none
  }
}

private func calculateOpacity(by yOffset: CGFloat) -> CGFloat {
  let slope: CGFloat = -1.0 / Constant.saveScrollYOffset
  return slope * yOffset + 1
}
