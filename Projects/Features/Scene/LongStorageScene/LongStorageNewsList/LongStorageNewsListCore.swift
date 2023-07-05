//
//  LongStorageNewsListCore.swift
//  Scene
//
//  Created by GREEN on 2023/04/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import Common
import ComposableArchitecture
import Foundation

public struct LongStorageNewsListState: Equatable {
  var isInEditMode: Bool
  var month: String
  var shortsNewsItemsCount: Int // 저장한 숏스 수
  var shortsCompleteCount: Int // 완료한 숏스 수
  // 전체 오래된 숏스
  var allShortsNewsItems: IdentifiedArrayOf<LongShortsItemState> = []
  // 필터링된 오래된 숏스
  var shortsNewsItems: IdentifiedArrayOf<LongShortsItemState> = []
  var isLatestMode: Bool = true
  var sortType: SortType
  var sortBottomSheetState: SortBottomSheetState
  // 카테고리 변경 바텀 시트
  var categoryFilterBottomSheetState: CategoryFilterBottomSheetState
  // 현재 카테고리
  var selectedCategories: Set<CategoryType>
  
  public init(
    isInEditMode: Bool,
    shortslistCount: Int,
    shortsClearCount: Int
  ) {
    self.isInEditMode = isInEditMode
    self.month = Date().yearMonthToString()
    self.shortsNewsItemsCount = shortslistCount
    self.shortsCompleteCount = shortsClearCount
    self.sortType = .latest
    self.sortBottomSheetState = SortBottomSheetState(sortType: .latest, isPresented: false)
    self.categoryFilterBottomSheetState = CategoryFilterBottomSheetState()
    self.selectedCategories = Set(CategoryType.allCases)
  }
}

public enum LongStorageNewsListAction {
  // MARK: - User Action
  case backButtonTapped
  case editButtonTapped
  case deleteButtonTapped
  case datePickerTapped
  case previousMonthButtonTapped
  case nextMonthButtonTapped
  case showSortBottomSheet
  case showCategoryFilterBottomSheet
  
  // MARK: - Inner Business Action
  case _onAppear
  case _sortLongShortsItems(SortType)
  case _filterLongShortsItems
  
  // MARK: - Inner SetState Action
  case _setEditMode
  case _setLongShortsItemEditMode
  case _setLongShortsItemList
  case _setLongShortsItemCount
  case _setSortType(SortType)
  case _setFilteredCategories(Set<CategoryType>)
  
  // MARK: - Child Action
  case shortsNewsItem(id: LongShortsItemState.ID, action: LongShortsItemAction)
  case sortBottomSheet(SortBottomSheetAction)
  case categoryFilterBottomSheet(CategoryFilterBottomSheetAction)
}

public struct LongStorageNewsListEnvironment {
  public init() {}
}

public let longStorageNewsListReducer = Reducer<
  LongStorageNewsListState,
  LongStorageNewsListAction,
  LongStorageNewsListEnvironment
>.combine([
  longShortsItemReducer
    .forEach(
      state: \LongStorageNewsListState.shortsNewsItems,
      action: /LongStorageNewsListAction.shortsNewsItem(id:action:),
      environment: { _ in
        LongShortsItemEnvironment()
      }
    ),
  sortBottomSheetReducer
    .pullback(
      state: \.sortBottomSheetState,
      action: /LongStorageNewsListAction.sortBottomSheet,
      environment: { _ in SortBottomSheetEnvironment() }
    ),
  categoryFilterBottomSheetReducer
    .pullback(
      state: \.categoryFilterBottomSheetState,
      action: /LongStorageNewsListAction.categoryFilterBottomSheet,
      environment: { _ in CategoryFilterBottomSheetEnvironment() }
    ),
  Reducer { state, action, env in
    switch action {
    case .editButtonTapped:
      return Effect.concatenate([
        Effect(value: ._setEditMode),
        Effect(value: ._setLongShortsItemEditMode)
      ])
      
    case .deleteButtonTapped:
      return Effect.concatenate([
        Effect(value: ._setEditMode),
        Effect(value: ._setLongShortsItemList),
        Effect(value: ._setLongShortsItemEditMode)
      ])
      
    case .showSortBottomSheet:
      return Effect(value: .sortBottomSheet(._setIsPresented(true)))
      
    case .showCategoryFilterBottomSheet:
      state.categoryFilterBottomSheetState = .init(selectedCategories: state.selectedCategories)
      return Effect(value: .categoryFilterBottomSheet(._setIsPresented(true)))
      
    case ._onAppear:
      // TODO: 서버에서 받아오는 데이터로 교체
      state.allShortsNewsItems = LongStorageStub.items
      state.shortsNewsItems = LongStorageStub.items
      return .none
      
    case let ._sortLongShortsItems(sortType):
      var sortedShortsNewsItems = state.shortsNewsItems
      if sortType == .latest {
        sortedShortsNewsItems.sort(by: {
          $0.cardState.news.writtenDateTime > $1.cardState.news.writtenDateTime
        })
      } else {
        sortedShortsNewsItems.sort(by: {
          $0.cardState.news.writtenDateTime < $1.cardState.news.writtenDateTime
        })
      }
      state.shortsNewsItems = sortedShortsNewsItems
      return .none
      
    case ._filterLongShortsItems:
      var filteredShortsNewsItems = state.allShortsNewsItems.filter {
        if let category = CategoryType(rawValue: $0.cardState.news.type) {
          return state.selectedCategories.contains(category)
        }
        return false
      }
      state.shortsNewsItems = filteredShortsNewsItems
      return .none
      
    case ._setEditMode:
      state.isInEditMode.toggle()
      return .none
      
    case ._setLongShortsItemEditMode:
      for index in 0..<state.shortsNewsItems.count {
        state.shortsNewsItems[index].isInEditMode = state.isInEditMode
        state.shortsNewsItems[index].cardState.isCardSelectable = !state.isInEditMode
      }
      return .none
      
    case ._setLongShortsItemList:
      state.shortsNewsItems.removeAll(where: \.isSelected)
      return Effect(value: ._setLongShortsItemCount)
      
    case ._setLongShortsItemCount:
      state.shortsNewsItemsCount = state.shortsNewsItems.count
      return .none
      
    case let ._setSortType(sortType):
      state.sortType = sortType
      return .none
      
    case let ._setFilteredCategories(filteredCategories):
      state.selectedCategories = filteredCategories
      return .none
      
    case let .sortBottomSheet(._sort(sortType)):
      return Effect.concatenate(
        Effect(value: ._setSortType(sortType)),
        Effect(value: ._sortLongShortsItems(sortType)),
        Effect(value: .sortBottomSheet(._setIsPresented(false)))
      )
      
    case let .categoryFilterBottomSheet(._filter(categories)):
      return Effect.concatenate(
        Effect(value: ._setFilteredCategories(categories)),
        Effect(value: ._filterLongShortsItems),
        Effect(value: .categoryFilterBottomSheet(._setIsPresented(false)))
      )
      
    default: return .none
    }
  }
])
