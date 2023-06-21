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
}

extension NewsCardService {
  public static let live = Self(
    getAllNewsCards: { targetDateTime, cursorId, pagingSize in
      return Provider<NewsCardAPI>
        .init(stubBehavior: .immediate)
        .request(
          NewsCardAPI.getAllNewsCards(targetDateTime, cursorId, pagingSize),
          type: [NewsCardsResponseDTO].self
        )
        .compactMap { $0 }
        .map { $0.map { $0.toDomain }}
        .eraseToEffect()
    }
  )
}
