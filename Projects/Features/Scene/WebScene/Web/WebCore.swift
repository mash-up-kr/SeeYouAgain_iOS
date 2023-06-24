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
  var webAddress: String
  var saveButtonDisabled: Bool
  var isDisplayTooltip: Bool
  var saveToastMessage: String?
  var warningToastMessage: String?
  
  public init(
    webAddress: String,
    saveButtonDisabled: Bool = false,
    isDisplayTooltip: Bool = true
  ) {
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
  
  // MARK: - Inner SetState Action
  case _setSaveButtonDisabled(Bool)
  case _setIsDisplayTooltip(Bool)
  case _setSaveToastMessage(String?)
  case _setWarningToastMessage(String?)
}

public struct WebEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  
  public init(mainQueue: AnySchedulerOf<DispatchQueue> = .main) {
    self.mainQueue = mainQueue
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
      // TODO: - 추후 뉴스 저장 API 구현
      // TODO: - 뉴스 저장에 따른 리스폰스를 통해 토스트 메시지 노출 (저장완료 or 에러)
      // TODO: - 저장 버튼 상태값 변경
      return Effect(value: ._setSaveButtonDisabled(true))
      
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
