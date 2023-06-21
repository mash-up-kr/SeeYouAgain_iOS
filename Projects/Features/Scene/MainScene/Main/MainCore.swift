//
//  MainCore.swift
//  Main
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Foundation
import Models
import Services

private enum Constant {
  static let defaultLetterWidth: CGFloat = 280
  static let defaultLetterHeight: CGFloat = 378
  static let iphone13MiniWidth: CGFloat = 375
  static let iphone13MiniHeight: CGFloat = 812
}

public typealias Category = Models.Category
public struct MainState: Equatable {
  var screenSize: CGSize = .zero
  var letterSize: CGSize = .zero
  
  var isLoading: Bool = false
  var categories: [Category] = []
  var letterScrollState: LetterScrollState?
  public init() { }
}

public enum MainAction {
  // MARK: - User Action
  case showCategoryBottomSheet([Category])
  
  // MARK: - Inner Business Action
  case _viewWillAppear(CGSize)
  case _fetchCategories
  case _updateCategories
  case _fetchLetters
  case _calculateLetterSize
  
  // MARK: - Inner SetState Action
  case _setIsLoading(Bool)
  case _setCategories([Category])
  case _setLetterScrollState(LetterLayout)
  
  // MARK: - Child Action
  case letterScrollAction(LetterScrollAction)
}

public struct MainEnvironment {
  let newsCardService: NewsCardService = .live
  public init() {}
}

public let mainReducer = Reducer.combine([
  letterScrollReducer
    .optional()
    .pullback(
      state: \.letterScrollState,
      action: /MainAction.letterScrollAction,
      environment: { _ in LetterScrollEnvironmnet() }
    ),
  Reducer<MainState, MainAction, MainEnvironment> { state, action, env in
    switch action {
    case let ._viewWillAppear(screen):
      state.screenSize = screen
      return Effect.concatenate([
        Effect(value: ._setIsLoading(true)),
        Effect(value: ._fetchCategories),
        Effect(value: ._fetchLetters),
        Effect(value: ._setIsLoading(false))
      ])
      
    case ._fetchCategories:
      state.categories = Category.stub
      return .none
      
    case ._updateCategories:
      // TODO: update categories to sever
      return .none
      
    case ._fetchLetters:
      return Effect(value: ._calculateLetterSize)
      
    case ._calculateLetterSize:
      let letterLayout = buildLetterLayout(screenSize: state.screenSize)
      return Effect(value: ._setLetterScrollState(letterLayout))
      
    case let ._setIsLoading(isLoading):
      state.isLoading = isLoading
      return .none
      
    case let ._setCategories(categories):
      state.categories = categories
      return .none
      
    case let ._setLetterScrollState(letterLayout):
      state.letterSize = letterLayout.size
      state.letterScrollState = LetterScrollState(
        letters: NewsCard.stub,
        layout: buildLetterLayout(
          screenSize: state.screenSize
        )
      )
      return .none
      
    default:
      return .none
    }
  }
])

private func buildLetterLayout(screenSize: CGSize) -> LetterLayout {
  let deviceRatio = CGSize(
    width: screenSize.width / Constant.iphone13MiniWidth,
    height: screenSize.height / Constant.iphone13MiniHeight
  )
  let letterSize = CGSize(
    width: Constant.defaultLetterWidth * deviceRatio.width,
    height: Constant.defaultLetterHeight * deviceRatio.height
  )
  let letterSpacing = (screenSize.width - letterSize.width) / 5
  let leadingOffset = (screenSize.width - letterSize.width) / 2
  
  return LetterLayout(
    ratio: deviceRatio,
    size: letterSize,
    spacing: letterSpacing,
    leadingOffset: leadingOffset
  )
}
