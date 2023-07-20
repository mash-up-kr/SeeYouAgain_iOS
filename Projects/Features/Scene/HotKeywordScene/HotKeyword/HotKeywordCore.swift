//
//  HotKeywordCore.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import DesignSystem
import Foundation
import Models
import Services

public struct HotKeywordState: Equatable {
  var hotKeywordList: [String] = []
  var subTitleText: String = ""
  var hotKeywordPointList = HotKeywordPointList(hotkeywordList: [])
  var isRefresh: Bool = false
  var isFirstLoading: Bool = true
  var currentOffset: CGFloat = 0
  var toastMessage: String?
  var isScrollToLeading: Bool = false
  var isHotkeywordVisiable: Bool = false
  var isAllowHitTest: Bool = true
  
  public init() { }
}

public enum HotKeywordAction: Equatable {
  // MARK: - User Action
  case backToForeground
  case pullToRefresh
  case hotKeywordCircleTapped(String, currentOffset: CGFloat)
  case hotkeywordTabTapped
  case otherTabsTapped
  
  // MARK: - Inner Business Action
  case _fetchData
  case _reloadData(HotKeywordDTO)
  case _showAnimation
  case _presentToast(String)
  case _hideToast
  
  // MARK: - Inner SetState Action
  case _setToastMessage(String?)
  case _setSubTitleText(String?)
  case _setHotKeywordList([String])
  case _setHotKeywordPointList
  case _setIsRefresh(Bool)
  case _setIsFirstLoading(Bool)
  case _setCurrentOffset(CGFloat)
  case _setHotkeywordVisiable(Bool)
  case _setIsScrollToLeading(Bool)
  case _setAllowHitTest(Bool)
  
  // MARK: - Child Action
  case showKeywordNewsList(String)
}

public struct HotKeywordEnvironment {
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

public let hotKeywordReducer = Reducer.combine([
  Reducer<HotKeywordState, HotKeywordAction, HotKeywordEnvironment> { state, action, env in
    struct SetHotKeywordToastCancelID: Hashable {}
    
    switch action {
    case .backToForeground:
      return .concatenate([
        Effect(value: ._setIsFirstLoading(true)),
        Effect(value: .pullToRefresh),
      ])
      
    case .pullToRefresh:
      return .concatenate([
        Effect(value: ._setAllowHitTest(false)),
        Effect(value: ._fetchData),
        Effect(value: ._setIsRefresh(true))
      ])
      
    case let .hotKeywordCircleTapped(keyword, offset):
      guard keyword.isEmpty == false else {
        return .none
      }
      return .concatenate([
        Effect(value: .showKeywordNewsList(keyword)),
        Effect(value: ._setCurrentOffset(offset))
      ])
      
    case .hotkeywordTabTapped:
      return .concatenate([
        Effect(value: ._setIsFirstLoading(false)),
        Effect(value: ._setIsScrollToLeading(true)),
        Effect(value: ._setHotkeywordVisiable(true))
      ])
      
    case .otherTabsTapped:
      return Effect(value: ._setHotkeywordVisiable(false))
      
    case ._fetchData:
      return env.hotKeywordService.fetchHotKeyword()
        .catchToEffect()
        .flatMapLatest { result -> Effect<HotKeywordAction, Never> in
          switch result {
          case let .success(hotKeywordDTO):
            return .concatenate([
              Effect(value: ._reloadData(hotKeywordDTO)),
              Effect(value: ._setAllowHitTest(true))
            ])
            
          case .failure:
            return .concatenate([
              Effect(value: ._presentToast("인터넷 연결 상태가 불안정합니다.")),
              Effect(value: ._setSubTitleText(nil)),
              Effect(value: ._setAllowHitTest(true))
            ])
          }
        }
        .eraseToEffect()
      
    case let ._reloadData(hotKeywordDTO):
      return .concatenate([
        Effect(value: ._setSubTitleText(hotKeywordDTO.standardTimeString)),
        Effect(value: ._setHotKeywordList(hotKeywordDTO.ranking)),
        Effect(value: ._setHotKeywordPointList)
      ])
      
    case let ._setSubTitleText(subTitle):
      if let subTitle {
        state.subTitleText = subTitle
      } else {
        state.subTitleText = "인터넷 연결 상태가 불안정합니다."
      }
      return .none
      
    case let ._setHotKeywordList(ranking):
      state.hotKeywordList = ranking
      return .none
      
    case ._setHotKeywordPointList:
      let currentPattern = state.hotKeywordPointList.pattern
      state.hotKeywordPointList = HotKeywordPointList(
        hotkeywordList: state.hotKeywordList,
        hotKeywordPattern: HotKeywordPatternSpace.generatePattern(without: currentPattern)
      )
      return .none
      
    case ._showAnimation:
      state.hotKeywordPointList = HotKeywordPointList(
        hotkeywordList: state.hotKeywordList,
        hotKeywordPattern: state.hotKeywordPointList.pattern
      )
      return .none
      
    case let ._presentToast(toastMessage):
      return .concatenate([
        Effect(value: ._setToastMessage(toastMessage)),
        .cancel(id: SetHotKeywordToastCancelID()),
        Effect(value: ._hideToast)
          .delay(for: 2, scheduler: env.mainQueue)
          .eraseToEffect()
          .cancellable(id: SetHotKeywordToastCancelID(), cancelInFlight: true)
      ])
      
    case ._hideToast:
      return Effect(value: ._setToastMessage(nil))
      
    case let ._setToastMessage(toastMessage):
      state.toastMessage = toastMessage
      return .none
      
    case let ._setIsRefresh(isRefresh):
      state.isRefresh = isRefresh
      return .none
      
    case let ._setIsFirstLoading(isFirstLoading):
      state.isFirstLoading = isFirstLoading
      return .none
      
    case let ._setCurrentOffset(offset):
      state.currentOffset = offset
      return .none
      
    case let .showKeywordNewsList(keyword):
      return .none
      
    case let ._setIsScrollToLeading(canScrollToLeading):
      state.isScrollToLeading = state.isHotkeywordVisiable && canScrollToLeading
      return .none
      
    case let ._setHotkeywordVisiable(isHotkeywordVisiable):
      state.isHotkeywordVisiable = isHotkeywordVisiable
      return .none
      
    case let ._setAllowHitTest(isAllowHitTest):
      state.isAllowHitTest = isAllowHitTest
      return .none
    }
  }
])
