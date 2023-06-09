//
//  MyPageCore.swift
//  MyPage
//
//  Created by 안상희 on 2023/05/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

public struct MyPageState: Equatable {
  var info: MyInfoState = MyInfoState(user: .stub)
  
  public init() {}
}

public enum MyPageAction {
  // MARK: - User Action
  case settingButtonTapped
  
  // MARK: - Inner Business Action
  case _viewWillAppear
  case _fetchUserInfo
  
  // MARK: - Inner SetState Action
  case _setMyInfoState(User)
   
   // MARK: - Inner SetState Action

  // MARK: - Child Action
  case info(MyInfoAction)
}

public struct MyPageEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let myPageService: MyPageService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    myPageService: MyPageService
  ) {
    self.mainQueue = mainQueue
    self.myPageService = myPageService
  }
}

fileprivate enum CancelID: Hashable, CaseIterable {
  case _fetchUserInfo
}

public let myPageReducer = Reducer<
  MyPageState,
  MyPageAction,
  MyPageEnvironment
>.combine([
  myInfoReducer
    .pullback(
      state: \MyPageState.info,
      action: /MyPageAction.info,
      environment: {
        MyInfoEnvironment(myPageService: $0.myPageService)
      }
    ),
  Reducer { state, action, env in
    switch action {
    case ._viewWillAppear:
      return Effect(value: ._fetchUserInfo)
      
    case ._fetchUserInfo:
      return env.myPageService.getMemberInfo()
        .catchToEffect()
        .flatMap { result -> Effect<MyPageAction, Never> in
          switch result {
          case let .success(user):
            return Effect(value: ._setMyInfoState(user))
            
          case .failure:
            return .none
          }
        }
        .eraseToEffect()
      
    case let ._setMyInfoState(user):
      state.info = MyInfoState(user: user)
      return .none
      
    default: return .none
    }
  }
])
