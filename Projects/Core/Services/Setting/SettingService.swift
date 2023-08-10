//
//  SettingService.swift
//  Core
//
//  Created by 김영균 on 2023/08/10.
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

public struct SettingService {
  public var addInterstCompanies: (_ companies: [String]) -> Effect<VoidResponse?, Error>
  public var changeMode: (_ modes: [String]) -> Effect<VoidResponse?, Error>
  
  private init(
    addInterstCompanies: @escaping (_ companies: [String]) -> Effect<VoidResponse?, Error>,
    changeMode: @escaping (_ modes: [String]) -> Effect<VoidResponse?, Error>
  ) {
    self.addInterstCompanies = addInterstCompanies
    self.changeMode = changeMode
  }
}

extension SettingService {
  public static let live = Self(
    addInterstCompanies: { companies in
      return Provider<SettingAPI>
        .init()
        .request(
          SettingAPI.addInterstCompanies(companies: companies),
          type: VoidResponse.self
        )
        .eraseToEffect()
    },
    changeMode: { modes in
      return Provider<SettingAPI>
        .init()
        .request(
          SettingAPI.changeMode(modes: modes),
          type: VoidResponse.self
        )
        .eraseToEffect()
    }
  )
}
