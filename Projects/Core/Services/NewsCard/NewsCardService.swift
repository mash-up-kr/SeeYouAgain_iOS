//
//  NewsCardService.swift
//  CoreKit
//
//  Created by 김영균 on 2023/06/19.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Common
import ComposableArchitecture
import Foundation
import Models

#if DEBUG
import XCTestDynamicOverlay
#endif

public struct NewsCardService {
  public var getAllNewsCards: (
    _ targetDateTime: Date,
    _ cursorId: Int,
    _ pagingSize: Int
  ) -> Effect<[NewsCard], Error>
  
  public var saveNewsCard: (_ newsCardId: Int) -> Effect<VoidResponse?, Error>
  public var getNewsCard: (_ newsCardId: Int) -> Effect<[NewsResponseDTO], Error>
  public var completeTodayShorts: (_ shortsId: Int) -> Effect<Int, Error>
  public var fetchShorts: (
    _ keyword: String,
    _ targetDateTime: Date,
    _ cursorId: Int,
    _ pagingSize: Int
  ) -> Effect<[NewsResponseDTO], Error>
}

extension NewsCardService {
  public static let live = Self(
    getAllNewsCards: { targetDateTime, cursorId, pagingSize in
      return Provider<NewsCardAPI>
        .init()
        .request(
          NewsCardAPI.getAllNewsCards(targetDateTime, cursorId, pagingSize),
          type: [NewsCardsResponseDTO].self
        )
        .compactMap { $0 }
        .map { $0.map { $0.toDomain }}
        .eraseToEffect()
    },
    saveNewsCard: { newsCardId in
      return Provider<NewsCardAPI>
        .init()
        .request(
          NewsCardAPI.saveNewsCard(newsCardId),
          type: VoidResponse.self
        )
        .eraseToEffect()
    },
    getNewsCard: { newsCardId in
      return Provider<NewsCardAPI>
        .init()
        .request(
          NewsCardAPI.getNewsCard(newsCardId),
          type: [NewsResponseDTO].self
        )
        .compactMap { $0 }
        .eraseToEffect()
    },
    completeTodayShorts: { shortsId in
      return Provider<NewsCardAPI>
        .init()
        .request(
          NewsCardAPI.completeTodayShorts(shortsId),
          type: CompleteTodayShortsResponseDTO.self
        )
        .compactMap { $0 }
        .map { $0.toDomain }
        .eraseToEffect()
    },
    fetchShorts: { keyword, targetDateTime, cursorId, pagingSize in
      return Provider<NewsCardAPI>
        .init()
        .request(
          NewsCardAPI.fetchShorts(keyword, targetDateTime, cursorId, pagingSize),
          type: [NewsResponseDTO].self
        )
        .compactMap { $0 }
        .eraseToEffect()
    }
  )
}
