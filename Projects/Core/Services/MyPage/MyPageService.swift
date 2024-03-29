//
//  MyPageService.swift
//  Services
//
//  Created by 안상희 on 2023/06/27.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import ComposableArchitecture
#if os(watchOS)
import ModelsWatchOS
#else
import Models
#endif

#if DEBUG
import XCTestDynamicOverlay
#endif

public struct MyPageService {
  public var getMemberInfo: () -> Effect<User, Error>
  public var fetchMemberNewsCard: (
    _ cursorId: Int,
    _ pagingSize: Int
  ) -> Effect<KeywordNews, Error>
  public var deleteTodayShorts: (_ shortsIds: [Int]) -> Effect<VoidResponse?, Error>
  public var fetchSavedNews: (
    _ targetDateTime: String,
    _ size: Int
  ) -> Effect<SavedNewsList, Error>
  public var deleteNews: (_ newsIds: [Int]) -> Effect<VoidResponse?, Error>
  public var getAchievementBadges: () -> Effect<[Achievement], Error>
  public var fetchWeeklyStats: () -> Effect<Statistics, Error>
}

extension MyPageService {
  public static let live = Self(
    getMemberInfo: {
      return Provider<MyPageAPI>
        .init()
        .request(
          MyPageAPI.getMemberInfo,
          type: MemberInfoResponseDTO.self
        )
        .compactMap { $0 }
        .map { $0.toDomain }
        .eraseToEffect()
    },
    fetchMemberNewsCard: { cursorId, pagingSize in
      return Provider<MyPageAPI>
        .init()
        .request(
          MyPageAPI.fetchKeywordNewsCard(cursorId, pagingSize),
          type: KeywordNewsCardResponseDTO.self
        )
        .compactMap { $0 }
        .map { $0.toDomain }
        .eraseToEffect()
    },
    deleteTodayShorts: { shortsIds in
      return Provider<MyPageAPI>
        .init()
        .request(
          MyPageAPI.deleteTodayShorts(shortsIds),
          type: VoidResponse.self
        )
        .compactMap { $0 }
        .eraseToEffect()
    },
    fetchSavedNews: { targetDateTime, size in
      return Provider<MyPageAPI>
        .init()
        .request(
          MyPageAPI.fetchSavedNews(
            targetDateTime,
            size
          ),
          type: SavedNewsResponseDTO.self
        )
        .compactMap { $0 }
        .map { $0.toDomain }
        .eraseToEffect()
    },
    deleteNews: { newsIds in
      return Provider<MyPageAPI>
        .init()
        .request(
          MyPageAPI.deleteSavedNews(newsIds),
          type: VoidResponse.self
        )
        .compactMap { $0 }
        .eraseToEffect()
    },
    getAchievementBadges: {
      return Provider<MyPageAPI>
        .init()
        .request(MyPageAPI.getAchievementBadges, type: AchievementResponseDTO.self)
        .compactMap { $0 }
        .map { $0.toDomain }
        .eraseToEffect()
    },
    fetchWeeklyStats: {
      return Provider<MyPageAPI>
        .init()
        .request(
          MyPageAPI.fetchWeeklyStats,
          type: StatisticsResponseDTO.self
        )
        .compactMap { $0 }
        .map { $0.toDomain }
        .eraseToEffect()
    }
  )
}
