//
//  NewsCardService.swift
//  CoreKit
//
//  Created by 김영균 on 2023/06/19.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
#if os(watchOS)
import CommonWatchOS
import ModelsWatchOS
#else
import Common
import Models
#endif
import ComposableArchitecture
import Foundation

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
  public var fetchNews: (
    _ keyword: String,
    _ targetDateTime: Date,
    _ cursorId: Int,
    _ pagingSize: Int
  ) -> Effect<[NewsResponseDTO], Error>
  
  public var saveNews: (_ newsId: Int) -> Effect<VoidResponse?, Error>
  public var checkSavedStatus: (_ newsId: Int) -> Effect<CheckSavedStatusResponseDTO, Error>
}

extension NewsCardService {
  public static let live = Self(
    getAllNewsCards: { targetDateTime, cursorId, pagingSize in
      return Provider<NewsCardAPI>
        .init()
        .request(
          NewsCardAPI.getAllNewsCards(targetDateTime, cursorId, pagingSize),
          type: AllNewsCardResponseDTO.self
        )
        .compactMap { $0 }
        .map { $0.newsCard.map { $0.toDomain }}
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
    fetchNews: { keyword, targetDateTime, cursorId, pagingSize in
      return Provider<NewsCardAPI>
        .init()
        .request(
          NewsCardAPI.hotkeywordFetchNews(keyword, targetDateTime, cursorId, pagingSize),
          type: [NewsResponseDTO].self
        )
        .compactMap { $0 }
        .eraseToEffect()
    },
    saveNews: { newsId in
      return Provider<NewsCardAPI>
        .init()
        .request(
          NewsCardAPI.saveNews(newsId),
          type: VoidResponse.self
        )
        .compactMap { $0 }
        .eraseToEffect()
    },
    checkSavedStatus: { newsId in
      return Provider<NewsCardAPI>
        .init()
        .request(
          NewsCardAPI.checkSavedStatus(newsId),
          type: CheckSavedStatusResponseDTO.self
        )
        .compactMap { $0 }
        .eraseToEffect()
    }
  )
}
