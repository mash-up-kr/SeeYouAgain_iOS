//
//  LogService.swift
//  Core
//
//  Created by 김영균 on 2023/08/03.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import ComposableArchitecture
import Foundation

public struct LogService {
  public var attendance: () -> Effect<VoidResponse?, Error>
  public var sharing: () -> Effect<VoidResponse?, Error>
}

extension LogService {
  public static let live = Self(
    attendance: {
      return Provider<LogAPI>
        .init()
        .request(LogAPI.attendance, type: VoidResponse.self)
        .eraseToEffect()
    },
    sharing: {
      return Provider<LogAPI>
        .init()
        .request(LogAPI.sharing, type: VoidResponse.self)
        .eraseToEffect()
    }
  )
}
