//
//  SortBottomSheetCore.swift
//  CoreKit
//
//  Created by 김영균 on 2023/07/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import ComposableArchitecture
import Foundation

public enum SortType: String {
  case latest = "최신순"
  case outdated = "오래된 순"
}

public struct SortBottomSheetState: Equatable {
  public var sortType: SortType
  public var isPresented: Bool
  
  public init(
    sortType: SortType = .latest,
    isPresented: Bool = false
  ) {
    self.sortType = sortType
    self.isPresented = isPresented
  }
}

public enum SortBottomSheetAction {
  // MARK: User Action
  case confirmBottomButtonTapped
  
  // MARK: Inner Business Action
  case _sort(SortType) // 상위 코어에 전달하는 액션.
  
  // MARK: Inner Set State Action
  case _setSortType(SortType)
  case _setIsPresented(Bool)
}

public struct SortBottomSheetEnvironment {
  public init() { }
}

public let sortBottomSheetReducer = Reducer<
  SortBottomSheetState,
  SortBottomSheetAction,
  SortBottomSheetEnvironment
> { state, action, _ in
  switch action {
  case .confirmBottomButtonTapped:
    return Effect(value: ._sort(state.sortType))
    
  case ._sort:
    return .none
    
  case let ._setSortType(sortType):
    state.sortType = sortType
    return .none
    
  case let ._setIsPresented(isPresented):
    state.isPresented = isPresented
    return .none
  }
}
