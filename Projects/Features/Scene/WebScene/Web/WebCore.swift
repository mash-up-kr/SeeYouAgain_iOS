//
//  WebCore.swift
//  Web
//
//  Created by GREEN on 2023/06/21.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import Common
import ComposableArchitecture
import Foundation
import Services

public struct WebState: Equatable {
  var newsId: Int
  var webAddress: String
  var saveButtonDisabled: Bool
  var isDisplayTooltip: Bool
  var saveToastMessage: String?
  var warningToastMessage: String?
  
  public init(
    newsId: Int,
    webAddress: String,
    saveButtonDisabled: Bool = false,
    isDisplayTooltip: Bool = true
  ) {
    self.newsId = newsId
    self.webAddress = webAddress
    self.saveButtonDisabled = saveButtonDisabled
    self.isDisplayTooltip = isDisplayTooltip
  }
}

public enum WebAction: Equatable {
  // MARK: - User Action
  case backButtonTapped
  case saveButtonTapped
  case tooltipButtonTapped
  
  // MARK: - Inner Business Action
  case _onAppear
  case _presentSaveToast(String)
  case _presentWaringToast(String)
  case _hideSaveToast
  case _hideWarningToast
  case _postNewsId(Int)
  
  // MARK: - Inner SetState Action
  case _setSaveButtonDisabled(Bool)
  case _setIsDisplayTooltip(Bool)
  case _setSaveToastMessage(String?)
  case _setWarningToastMessage(String?)
}

public struct WebEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let newsCardService: NewsCardService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue> = .main,
    newsCardService: NewsCardService
  ) {
    self.mainQueue = mainQueue
    self.newsCardService = newsCardService
  }
}

public let webReducer = Reducer.combine([
  Reducer<WebState, WebAction, WebEnvironment> { state, action, env in
    struct WebSaveToastCancelID: Hashable {}
    struct WebWarningToastCancelID: Hashable {}
    
    switch action {
    case ._onAppear:
      return .merge([
        Effect(value: ._setIsDisplayTooltip(false))
          .delay(for: 4, scheduler: env.mainQueue)
          .eraseToEffect(),
        // TODO: - 추후 해당 뉴스가 이미 저장된 뉴스인지 API 판별 후 저장 버튼 비활성화 처리 추가 필요
      ])
      
    case .backButtonTapped:
      return .none
      
    case .saveButtonTapped:
      return Effect(value: ._postNewsId(state.newsId))
      
    case .tooltipButtonTapped:
      return Effect(value: ._setIsDisplayTooltip(false))
      
    case let ._presentSaveToast(toastMessage):
      return .concatenate([
        Effect(value: ._setSaveToastMessage(toastMessage)),
        .cancel(id: WebSaveToastCancelID()),
        Effect(value: ._hideSaveToast)
          .delay(for: 2, scheduler: env.mainQueue)
          .eraseToEffect()
          .cancellable(id: WebSaveToastCancelID(), cancelInFlight: true)
      ])
      
    case let ._presentWaringToast(toastMessage):
      return .concatenate([
        Effect(value: ._setWarningToastMessage(toastMessage)),
        .cancel(id: WebWarningToastCancelID()),
        Effect(value: ._hideWarningToast)
          .delay(for: 2, scheduler: env.mainQueue)
          .eraseToEffect()
          .cancellable(id: WebWarningToastCancelID(), cancelInFlight: true)
      ])
      
    case ._hideSaveToast:
      return Effect(value: ._setSaveToastMessage(nil))
      
    case ._hideWarningToast:
      return Effect(value: ._setWarningToastMessage(nil))
      
    case let ._postNewsId(id):
      return env.newsCardService.saveNews(id)
        .catchToEffect()
        .flatMap { result -> Effect<WebAction, Never> in
          switch result {
          case .success:
            return Effect.concatenate([
              Effect(value: ._setSaveButtonDisabled(true)),
              Effect(value: ._presentSaveToast("오래 간직할 뉴스에 추가했어요."))
            ])
            
          case .failure:
            return Effect(value: ._presentWaringToast("인터넷이 불안정해서 저장되지 못했어요."))
          }
        }
        .eraseToEffect()
      
    case let ._setSaveButtonDisabled(disabled):
      state.saveButtonDisabled = disabled
      return .none
      
    case let ._setIsDisplayTooltip(isDisplay):
      if state.isDisplayTooltip == isDisplay {
        return .none
      }
      state.isDisplayTooltip = isDisplay
      return .none
    
    case let ._setSaveToastMessage(toastMessage):
      state.saveToastMessage = toastMessage
      return .none
      
    case let ._setWarningToastMessage(toastMessage):
      state.warningToastMessage = toastMessage
      return .none
    }
  }
])
