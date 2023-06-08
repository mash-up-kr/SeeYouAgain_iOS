//
//  BottomSheetCore.swift
//  Main
//
//  Created by 김영균 on 2023/06/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import CombineExt
import ComposableArchitecture
import Models

public struct BottomSheetState: Equatable {
  public var categories: [Category] = []
  public var isPresented: Bool = false
  
  public init() {}
}

public enum BottomSheetAction {
  case updateButtonTapped
  case closeBottomSheet
  case toggleCategory(Category)
}

public struct BottomSheetEnvironment {
  
}

public let bottomSheetReducer: Reducer<
  BottomSheetState,
  BottomSheetAction,
  BottomSheetEnvironment
> = Reducer { state, action, env in
  switch action {
  case let .toggleCategory(targetCategory):
    state.categories = state.categories.map { category in
      var updateCategory = category
      if targetCategory == updateCategory {
        updateCategory.isSelected.toggle()
      }
      return updateCategory
    }
    return .none
    
  case .closeBottomSheet:
    state.isPresented = false
    return .none
    
  default:
    return .none
  }
}
