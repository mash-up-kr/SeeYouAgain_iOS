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
import Models
import Services

public enum MonthType {
  case minus
  case plus
}

public struct LongStorageNewsListState: Equatable {
  var isInEditMode: Bool = false
  var month: String
  var shortsNewsItemsCount: Int = 0 // 저장한 숏스 수
  var allShortsNewsItems: IdentifiedArrayOf<LongShortsItemState> = [] // 전체 오래된 숏스
  var shortsNewsItems: IdentifiedArrayOf<LongShortsItemState> = [] // 필터링된 오래된 숏스
  var isLatestMode: Bool = true
  var sortType: SortType
  var sortBottomSheetState: SortBottomSheetState
  var categoryFilterBottomSheetState: CategoryFilterBottomSheetState // 카테고리 변경 바텀 시트
  var selectedCategories: Set<CategoryType> // 현재 카테고리
  var cursorDate: Date = .now
  var targetDate = Date().firstDayOfMonth() // 항상 해당 월의 1일로 데이터 조회
  var pagingSize: Int = 20
  var pivot: Pivot = .desc // 최신순이 기본값
  var successToastMessage: String?
  var failureToastMessage: String?
  var selectedItemCounts: Int = 0
  var isCurrentMonth: Bool = true // 현재 월이 가장 마지막 월인지 여부
  var currentMonth = Date().monthToString() // 현재 날짜에 해당하는 월
  var dateFilterBottomSheetState: DateFilterBottomSheetState // 날짜 변경 바텀 시트
  var dateType: DateType
  var isLoading: Bool = false
  
  public init() {
    self.month = Date().yearMonthToString()
    self.sortType = .latest
    self.sortBottomSheetState = SortBottomSheetState(sortType: .latest, isPresented: false)
    self.categoryFilterBottomSheetState = CategoryFilterBottomSheetState()
    self.dateFilterBottomSheetState = DateFilterBottomSheetState()
    self.selectedCategories = Set(CategoryType.allCases)
    self.dateType = .init(year: Date().yearToInt(), month: Date().monthToInt())
  }
}

public enum LongStorageNewsListAction {
  // MARK: - User Action
  case backButtonTapped
  case editButtonTapped
  case deleteButtonTapped
  case datePickerTapped
  case minusMonthButtonTapped
  case plusMonthButtonTapped
  case showSortBottomSheet
  case showCategoryFilterBottomSheet
  case showDateFilterBottomSheet
  
  // MARK: - Inner Business Action
  case _onDisappear
  case _sortLongShortsItems(SortType)
  case _filterLongShortsItems
  case _viewWillAppear
  case _fetchSavedNews(FetchType)
  case _handleFetchSavedNewsResponse(SavedNewsList, FetchType)
  case _deleteSavedNews([Int])
  case _handleDeleteSavedNewsResponse(Result<VoidResponse?, Error>)
  case _presentSuccessToast(String)
  case _presentFailureToast(String)
  case _hideSuccessToast
  case _hideFailureToast
  
  // MARK: - Inner SetState Action
  case _setEditMode
  case _setLongShortsItemEditMode
  case _setLongShortsItem([News])
  case _setLongShortsItemList
  case _setLongShortsItemCount
  case _setSortType(SortType)
  case _setFilteredCategories(Set<CategoryType>)
  case _setSelectedItemIds
  case _setSuccessToastMessage(String?)
  case _setFailureToastMessage(String?)
  case _setTargetDate(MonthType)
  case _setDateType(Date)
  case _setMonth
  case _setIsCurrentMonth
  case _setIsLoading(Bool)
  
  // MARK: - Child Action
  case shortsNewsItem(id: LongShortsItemState.ID, action: LongShortsItemAction)
  case sortBottomSheet(SortBottomSheetAction)
  case categoryFilterBottomSheet(CategoryFilterBottomSheetAction)
  case dateFilterBottomSheet(DateFilterBottomSheetAction)
}

public struct LongStorageNewsListEnvironment {
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
  dateFilterBottomSheetReducer
    .pullback(
      state: \.dateFilterBottomSheetState,
      action: /LongStorageNewsListAction.dateFilterBottomSheet,
      environment: { _ in DateFilterBottomSheetEnvironment() }
    ),
  Reducer { state, action, env in
    struct SuccessToastCancelID: Hashable {}
    struct FailureToastCancelID: Hashable {}
    
    switch action {
    case .editButtonTapped:
      return Effect.concatenate([
        Effect(value: ._setEditMode),
        Effect(value: ._setLongShortsItemEditMode)
      ])
      
    case .deleteButtonTapped:
      return Effect(value: ._setSelectedItemIds)
      
    case .datePickerTapped:
      return .none
      
    case .minusMonthButtonTapped:
      return Effect(value: ._setTargetDate(.minus))
      
    case .plusMonthButtonTapped:
      return Effect(value: ._setTargetDate(.plus))
      
    case .showSortBottomSheet:
      return Effect(value: .sortBottomSheet(._setIsPresented(true)))
      
    case .showCategoryFilterBottomSheet:
      state.categoryFilterBottomSheetState = .init(selectedCategories: state.selectedCategories)
      return Effect(value: .categoryFilterBottomSheet(._setIsPresented(true)))
      
    case .showDateFilterBottomSheet:
      state.dateFilterBottomSheetState = .init(
        year: state.dateType.year,
        month: state.dateType.month - 1
      )
      return Effect(value: .dateFilterBottomSheet(._setIsPresented(true)))
      
    case ._onDisappear:
      return Effect.merge(
        Effect(value: ._hideSuccessToast),
        Effect(value: ._hideFailureToast)
      )
    case ._viewWillAppear:
      return Effect.concatenate([
        Effect(value: ._setIsLoading(true)),
        Effect(value: ._fetchSavedNews(.initial))
      ])
      
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
        if let category = CategoryType(uppercasedName: $0.cardState.news.category) {
          return state.selectedCategories.contains(category)
        }
        return false
      }
      state.shortsNewsItems = filteredShortsNewsItems
      return .none
      
    case let ._fetchSavedNews(fetchType):
      return env.myPageService.fetchSavedNews(
        state.targetDate.toFormattedTargetDate(),
        state.pagingSize
      )
      .catchToEffect()
      .flatMap { result -> Effect<LongStorageNewsListAction, Never> in
        switch result {
        case let .success(savedNewsList):
          return Effect(value: ._handleFetchSavedNewsResponse(savedNewsList, fetchType))
          
        case .failure:
          return .none
        }
      }
      .eraseToEffect()
      
    case let ._handleFetchSavedNewsResponse(savedNewsList, fetchType):
      return .concatenate([
        Effect(value: ._setIsLoading(false)),
        handleSavedNewsResponse(&state, source: savedNewsList, fetchType: fetchType),
        Effect(value: ._sortLongShortsItems(state.sortType)),
      ])
      
    case let ._deleteSavedNews(newsIds):
      return env.myPageService.deleteNews(newsIds)
        .catchToEffect(LongStorageNewsListAction._handleDeleteSavedNewsResponse)
      
    case let ._handleDeleteSavedNewsResponse(result):
      switch result {
      case .success:
        return Effect.concatenate([
          Effect(value: ._setEditMode),
          Effect(value: ._setLongShortsItemList),
          Effect(value: ._setLongShortsItemEditMode),
          Effect(value: ._presentSuccessToast("\(state.selectedItemCounts)개의 숏스를 삭제했어요."))
        ])
        
      case .failure:
        return Effect(value: ._presentFailureToast("인터넷이 불안정해서 삭제되지 못했어요."))
      }
      
    case let ._presentSuccessToast(toastMessage):
      return Effect.concatenate([
        Effect(value: ._setSuccessToastMessage(toastMessage)),
        .cancel(id: SuccessToastCancelID()),
        Effect(value: ._hideSuccessToast)
          .delay(for: 2, scheduler: env.mainQueue)
          .eraseToEffect()
          .cancellable(id: SuccessToastCancelID(), cancelInFlight: true)
      ])
      
    case let ._presentFailureToast(toastMessage):
      return Effect.concatenate([
        Effect(value: ._setFailureToastMessage(toastMessage)),
        .cancel(id: FailureToastCancelID()),
        Effect(value: ._hideFailureToast)
          .delay(for: 2, scheduler: env.mainQueue)
          .eraseToEffect()
          .cancellable(id: FailureToastCancelID(), cancelInFlight: true)
      ])
      
    case ._hideSuccessToast:
      return Effect(value: ._setSuccessToastMessage(nil))
      
    case ._hideFailureToast:
      return Effect(value: ._setFailureToastMessage(nil))
      
    case ._setEditMode:
      state.isInEditMode.toggle()
      return .none
      
    case ._setLongShortsItemEditMode:
      for index in 0..<state.shortsNewsItems.count {
        state.shortsNewsItems[index].isInEditMode = state.isInEditMode
        state.shortsNewsItems[index].cardState.isCardSelectable = !state.isInEditMode
      }
      return .none

    case let ._setLongShortsItem(newsList):
      state.shortsNewsItems = IdentifiedArrayOf(uniqueElements: newsList.map {
        LongShortsItemState(
          id: $0.id,
          isInEditMode: false,
          isSelected: false,
          cardState: LongShortsCardState(
            id: $0.id,
            news: $0,
            isCardSelectable: true,
            isSelected: false
          )
        )
      })
      state.allShortsNewsItems = state.shortsNewsItems
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
      
    case ._setSelectedItemIds:
      var selectedItemIds: [Int] = []
      
      for item in state.shortsNewsItems {
        if item.isSelected {
          selectedItemIds.append(item.id)
        }
      }
      
      state.selectedItemCounts = selectedItemIds.count
      
      if selectedItemIds.isEmpty {
        return Effect.concatenate([
          Effect(value: ._setEditMode),
          Effect(value: ._setLongShortsItemEditMode)
        ])
      }
      return Effect(value: ._deleteSavedNews(selectedItemIds))
      
    case let ._setSuccessToastMessage(toastMessage):
      state.successToastMessage = toastMessage
      return .none
      
    case let ._setFailureToastMessage(toastMessage):
      state.failureToastMessage = toastMessage
      return .none
      
    case let ._setTargetDate(monthType):
      switch monthType {
      case .minus:
        state.targetDate = state.targetDate.minusMonth()

      case .plus:
        state.targetDate = state.targetDate.plusMonth()
      }
      
      return Effect.concatenate([
        Effect(value: ._setMonth),
        Effect(value: ._setIsCurrentMonth),
        Effect(value: ._setDateType(state.targetDate))
      ])
      
    case let ._setDateType(date):
      state.dateType = .init(year: date.yearToInt(), month: date.monthToInt())
      return .none
      
    case ._setMonth:
      state.month = state.targetDate.yearMonthToString()
      return Effect(value: ._fetchSavedNews(.initial))
      
    case ._setIsCurrentMonth:
      state.isCurrentMonth = state.targetDate.monthToString() == state.currentMonth
      return .none
      
    case let ._setIsLoading(isLoading):
      state.isLoading = isLoading
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
      
    case let .dateFilterBottomSheet(._filter(year, month)):
      state.targetDate = "\(year)-\(month)-01".toDate()
      
      return Effect.concatenate([
        Effect(value: ._setDateType(state.targetDate)),
        Effect(value: ._setIsCurrentMonth),
        Effect(value: .dateFilterBottomSheet(._setIsPresented(false))),
        Effect(value: ._fetchSavedNews(.initial))
      ])
      
    default: return .none
    }
  }
])

private func handleSavedNewsResponse(
  _ state: inout LongStorageNewsListState,
  source savedNewsList: SavedNewsList,
  fetchType: FetchType
) -> Effect<LongStorageNewsListAction, Never> {
  switch fetchType {
  case .initial:
    state.shortsNewsItemsCount = savedNewsList.savedNewsCount
    return Effect(value: ._setLongShortsItem(savedNewsList.newsList))
    
    // TODO: 페이징 기능 구현 필요
  case .continuousPaging:
    return .none

  case .newPaging:
    return .none
  }
}

fileprivate extension String {
  func toDate() -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-M-dd"
    dateFormatter.timeZone = TimeZone(identifier: "ko_kr")
    return dateFormatter.date(from: self)!
  }
}
