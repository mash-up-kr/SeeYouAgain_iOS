//
//  MyPageService.swift
//  Services
//
//  Created by 안상희 on 2023/06/27.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import ComposableArchitecture
import Foundation
import Models

#if DEBUG
import XCTestDynamicOverlay
#endif

public struct MyPageService {
  public var getMemberInfo: () -> Effect<User, Error>
  public var getTodayShorts: (
    _ cursorId: Int,
    _ pagingSize: Int
  ) -> Effect<TodayShorts, Error>
  public var deleteTodayShorts: (_ shortsIds: [Int]) -> Effect<VoidResponse?, Error>
  public var fetchSavedNews: (
    _ targetDateTime: String,
    _ size: Int,
    _ pivot: Pivot
  ) -> Effect<SavedNewsList, Error>
  public var deleteNews: (_ newsIds: [Int]) -> Effect<VoidResponse?, Error>
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
    getTodayShorts: { cursorId, pagingSize in
      return Provider<MyPageAPI>
        .init()
        .request(
          MyPageAPI.getTodayShorts(cursorId, pagingSize),
          type: TodayShortsResponseDTO.self
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
    fetchSavedNews: { targetDateTime, size, pivot in
      return Provider<MyPageAPI>
        .init()
        .request(
          MyPageAPI.fetchSavedNews(
            targetDateTime,
            size,
            pivot
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
    }
  )
}
