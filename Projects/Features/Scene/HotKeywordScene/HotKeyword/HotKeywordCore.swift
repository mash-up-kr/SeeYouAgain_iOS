//
//  HotKeywordCore.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation
import Models
import Services
import SwiftUI // 요상하네 이거 있는거

public struct HotKeywordState: Equatable {
  // 인덱스 숫자가 작을수록 큰 원
  public var hotKeywordList: [String] = []
  public var subTitleText: String = ""
  public var hotKeywordPointList = HotKeywordPointList(
    hotkeywordList: [],
    hotKeywordPattern: HotKeywordPatternSpace.generatePattern()
  )
    
  public init() { }
}

public enum HotKeywordAction: Equatable {
  // MARK: - User Action
  case viewDidLoad
  case _pullToRefresh
  
  // MARK: - Inner Business Action
  case _fetchData
  
  // MARK: - Inner SetState Action
  case _showAnimation
  
  // MARK: - Child Action
  case _reloadData(HotKeywordDTO)
}

public struct HotKeywordEnvironment {
  let hotKeywordService: HotKeywordService = .live

  public init() {}
}

public let hotKeywordReducer = Reducer.combine([
  Reducer<HotKeywordState, HotKeywordAction, HotKeywordEnvironment> { state, action, env in
    switch action {
    case .viewDidLoad:
      return Effect(value: ._fetchData)
      
    case ._pullToRefresh:
      return Effect(value: ._fetchData)
      
    case ._fetchData: // _fetchData랑 _reloadData 이름을 어케바꾸지
      return env.hotKeywordService.fetchHotKeyword()
        .catchToEffect() // 이게몰까 여기 메서드들 공부 필요
        .flatMapLatest { result -> Effect<HotKeywordAction, Never> in
          switch result {
          case let .success(hotKeywordDTO):
            return Effect(value: ._reloadData(hotKeywordDTO))
            
            // TODO: 에러처리 확인
          case let .failure(error):
            if let error = error.toProviderError() {
              return .none
            } else {
              return .none
            }
          }
        }
        .eraseToEffect()
      
    case let ._reloadData(hotKeywordDTO): // _fetchData랑 _reloadData 이름을 어케바꾸지
      state.subTitleText = hotKeywordDTO.createdAt
      state.hotKeywordList = hotKeywordDTO.ranking
      
      let currentPattern = state.hotKeywordPointList.pattern
      state.hotKeywordPointList = HotKeywordPointList(
        hotkeywordList: state.hotKeywordList,
        hotKeywordPattern: HotKeywordPatternSpace.generatePattern(without: currentPattern)
      )
      return .none
      
      // 탭 눌렀을때 호출
    case ._showAnimation:
      // TODO: 패턴은 그대로 뷰는 다시 그리기
      return .none
    }
  }
])
