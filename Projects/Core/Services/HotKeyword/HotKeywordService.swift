//
//  HotKeywordService.swift
//  CoreKit
//
//  Created by lina on 2023/06/18.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Common
import ComposableArchitecture
import Foundation
import Models

public struct HotKeywordService {
  public var fetchHotKeyword: () -> Effect<HotKeywordDTO, Error>
}

extension HotKeywordService {
  public static let live = Self(
    fetchHotKeyword: {
      return Provider<HotKeywordAPI>
        .init()
        .request(
          HotKeywordAPI.fetchHotKeyword,
          type: HotKeywordDTO.self
        )
        .compactMap { $0 }
        .eraseToEffect()
    }
  )
}
