//
//  SaveGuideCore.swift
//  Splash
//
//  Created by 김영균 on 2023/06/26.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Services

public struct SaveGuideState: Equatable {
  var caretDownOffset: CGSize = .zero
  
  public init() { }
}

public enum SaveGuideAction: Equatable {
  // MARK: - Inner Business Action
  case _onAppear
  case _updateLaunchStatus
  case _firstLaunchAnimation
  case _startAnimation
  
  // MARK: - Inner SetState Action  
  case _setCaretDownOffset(CGSize)
}

public struct SaveGuideEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let userDefaultsService: UserDefaultsService
  
  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    userDefaultsService: UserDefaultsService
  ) {
    self.mainQueue = mainQueue
    self.userDefaultsService = userDefaultsService
  }
}

public let saveGuideReducer = Reducer<
  SaveGuideState,
  SaveGuideAction,
  SaveGuideEnvironment
> { state, action, env in
  switch action {
  case ._onAppear:
    return env.userDefaultsService.load(.hasLaunched)
      .flatMapLatest { hasLaunched -> Effect<SaveGuideAction, Never> in
        if !hasLaunched {
          return Effect.merge(
            Effect(value: ._updateLaunchStatus),
            Effect(value: ._firstLaunchAnimation)
          )
        } else {
          return .none
        }
      }
      .eraseToEffect()
    
  case ._updateLaunchStatus:
    return env.userDefaultsService.save(.hasLaunched, true)
      .fireAndForget()
    
  case ._firstLaunchAnimation:
    return Effect.concatenate(
      Effect(value: ._startAnimation).delay(for: 2, scheduler: env.mainQueue).eraseToEffect(),
      Effect(value: ._startAnimation).delay(for: 2, scheduler: env.mainQueue).eraseToEffect(),
      Effect(value: ._startAnimation).delay(for: 2, scheduler: env.mainQueue).eraseToEffect()
    )
    
  case ._startAnimation:
    return .run { send in
      await send(._setCaretDownOffset(.init(width: 0, height: 10)))
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        send(._setCaretDownOffset(.init(width: 0, height: 0)))
      }
    }
    
  case let ._setCaretDownOffset(offset):
    state.caretDownOffset = offset
    return .none
  }
}
