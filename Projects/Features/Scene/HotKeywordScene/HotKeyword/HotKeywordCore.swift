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
import NewsList
import Models
import Services

public struct HotKeywordState: Equatable {
  var hotKeywordList: [String] = []
  var subTitleText: String = ""
  var hotKeywordPointList = HotKeywordPointList(hotkeywordList: [])
  var isRefresh: Bool = false
  var isFirstLoading: Bool = true
  var toastMessage: String?
  
  public init() { }
}

public enum HotKeywordAction: Equatable {
  // MARK: - User Action
  case pullToRefresh
  case hotKeywordCircleTapped(String)
  
  // MARK: - Inner Business Action
  case _viewWillAppear
  case _fetchData
  case _reloadData(HotKeywordDTO)
  case _showAnimation
  case _fetchKeywordShorts(String)
  case _presentToast(String)
  case _hideToast
  
  // MARK: - Inner SetState Action
  case _setToastMessage(String?)
  case _setSubTitleText(String?)
  case _setHotKeywordList([String])
  case _setHotKeywordPointList
  case _setIsRefresh(Bool)
  case _setIsFirstLoading(Bool)
  case _convertNewsItemsFromNewsCardsDTO([NewsCardsResponseDTO], String)
  
  // MARK: - Child Action
  case showKeywordNewsList(String, IdentifiedArrayOf<NewsCardState>)
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
    case .pullToRefresh:
      return .concatenate([
        Effect(value: ._fetchData),
        Effect(value: ._setIsRefresh(true))
      ])
      
    case let .hotKeywordCircleTapped(keyword):
      guard keyword.isEmpty == false else {
        return .none
      }
      return Effect(value: ._fetchKeywordShorts(keyword))
      
    case ._viewWillAppear:
      return .concatenate([
        Effect(value: ._setIsFirstLoading(false)),
        Effect(value: ._showAnimation)
      ])
      
    case ._fetchData:
      return env.hotKeywordService.fetchHotKeyword()
        .catchToEffect()
        .flatMapLatest { result -> Effect<HotKeywordAction, Never> in
          switch result {
          case let .success(hotKeywordDTO):
            return Effect(value: ._reloadData(hotKeywordDTO))
            
          case .failure:
            // lina-TODO: 아무것도 없는 경우 화면처리, subtitle 텍스트 변경, 로딩 중에 재시도 못하게 변경
            return Effect(value: ._presentToast("인터넷 연결 상태가 불안정합니다."))
          }
        }
        .eraseToEffect()
      
    case let ._reloadData(hotKeywordDTO):
      
      return .concatenate([
        Effect(value: ._setSubTitleText(hotKeywordDTO.createdAt)),
        Effect(value: ._setHotKeywordList(hotKeywordDTO.ranking)),
        Effect(value: ._setHotKeywordPointList)
      ])
      
    case let ._setSubTitleText(subTitle):
      if let subTitle {
        state.subTitleText = "\(subTitle) 기준"
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
      
    case let ._fetchKeywordShorts(keyword):
      return env.hotKeywordService.fetchKeywordShorts(keyword)
        .catchToEffect()
        .flatMapLatest { result -> Effect<HotKeywordAction, Never> in
          switch result {
          case let .success(newsCardsResponseDTO):
            return Effect(value: ._convertNewsItemsFromNewsCardsDTO(newsCardsResponseDTO, keyword))
            
          case .failure:
            return Effect(value: ._presentToast("인터넷 연결 상태가 불안정합니다."))
          }
        }
        .eraseToEffect()
      
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
      
    case let ._convertNewsItemsFromNewsCardsDTO(responseDTO, keyword):
      let keyword = "#\(keyword)"
      var newsItems: IdentifiedArrayOf<NewsCardState> = []
      responseDTO.forEach { response in
        newsItems.append(NewsCardState(newsCardsResponseDTO: response))
      }
      return Effect(value: .showKeywordNewsList(keyword, newsItems))
      
    case let .showKeywordNewsList(keyword, newsItems):
      return .none
    }
  }
])
