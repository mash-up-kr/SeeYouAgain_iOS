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
  var hotKeywordPointList = HotKeywordPointList(
    hotkeywordList: [],
    hotKeywordPattern: HotKeywordPatternSpace.generatePattern()
  )
  var isRefresh: Bool = false
  var toastMessage: String?

  public init() { }
}

public enum HotKeywordAction: Equatable {
  // MARK: - User Action
  case pullToRefresh
  
  // MARK: - Inner Business Action
  case _viewWillAppear
  case _fetchData
  case _reloadData(HotKeywordDTO)
  case _showAnimation
  case _presentToast(String)
  case _hideToast

  // MARK: - Inner SetState Action
  case _setToastMessage(String?)
  case _setIsRefresh(Bool)

  // MARK: - Child Action
  case hotKeywordCircleTapped
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
      
    case ._viewWillAppear:
      return Effect(value: ._showAnimation)
      
    case ._fetchData:
      return env.hotKeywordService.fetchHotKeyword()
        .catchToEffect()
        .flatMapLatest { result -> Effect<HotKeywordAction, Never> in
          switch result {
          case let .success(hotKeywordDTO):
            return Effect(value: ._reloadData(hotKeywordDTO))
            
          case .failure:
            let hotKeywordDTO = HotKeywordDTO(createdAt: "시간", ranking: [
              "뱀", "환경", "공연", "인공지능", "백신", "스포츠", "로봇", "기후변화", "인플레이션", "스타트업"
            ])
            return Effect(value: ._reloadData(hotKeywordDTO))
            // lina-TODO: 아무것도 없는 경우 화면처리, subtitle 텍스트 변경, 로딩 중에 재시도 못하게 변경
            return Effect(value: ._presentToast("인터넷 연결 상태가 불안정합니다."))
          }
        }
        .eraseToEffect()

    case let ._reloadData(hotKeywordDTO):
      state.subTitleText = hotKeywordDTO.createdAt
      state.hotKeywordList = hotKeywordDTO.ranking
      
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
      
    case .hotKeywordCircleTapped:
      return .none
    }
  }
])
