//
//  SetCategoryCore.swift
//  SetCategory
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import ComposableArchitecture
import Foundation

public struct SetCategoryState: Equatable {
  public init() { }
}

public enum SetCategoryAction: Equatable {
  // MARK: - User Action
  
  // MARK: - Inner Business Action
  
  // MARK: - Inner SetState Action
  
  // MARK: - Child Action
}

public struct SetCategoryEnvironment {
  public init() {}
}

public let setCategoryReducer = Reducer.combine([
  Reducer<SetCategoryState, SetCategoryAction, SetCategoryEnvironment> { state, action, env in
    switch action {
    }
  }
])
