//
//  AppVersionService.swift
//  CoreKit
//
//  Created by GREEN on 2023/06/19.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Combine
import CombineExt
import ComposableArchitecture
import Foundation
import Models

public struct AppVersionService {
  public let fetchAppVersion: () -> Effect<String, Never>
  public let fetchLastestAppVersion: (String) -> Effect<(String, Bool), Never>
  
  private init(
    fetchAppVersion: @escaping () -> Effect<String, Never>,
    fetchLastestAppVersion: @escaping (String) -> Effect<(String, Bool), Never>
  ) {
    self.fetchAppVersion = fetchAppVersion
    self.fetchLastestAppVersion = fetchLastestAppVersion
  }
}

public extension AppVersionService {
  static var live = Self.init(
    fetchAppVersion: {
      return Publishers.Create<String, Never>(factory: { subscriber -> Cancellable in
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
          subscriber.send(version)
        } else {
          subscriber.send("")
        }
        subscriber.send(completion: .finished)
        return AnyCancellable({})
      })
      .eraseToEffect()
    },
    fetchLastestAppVersion: { currentAppVersion in
      return Publishers.Create<(String, Bool), Never>(factory: { subscriber -> Cancellable in
        #if DEBUG
        let appID = "6448740360"
        #else
        let appID = "6447816671"
        #endif
        
        let url = URL(string: "https://itunes.apple.com/lookup?id=\(appID)")
        AF.request(url ?? "")
          .validate()
          .responseDecodable(of: AppStoreResponseDTO.self) { response in
            switch response.result {
            case let .success(appStoreResponse):
              if let appStoreVersion = appStoreResponse.results.first?.version {
                if currentAppVersion == appStoreVersion {
                  subscriber.send(("최신버전입니다.", true))
                } else {
                  subscriber.send(("최신버전이 아닙니다.", false))
                }
              } else {
                subscriber.send(("앱 스토어 정보를 가져오지 못했습니다.", false))
              }
              
            case .failure:
              subscriber.send(("앱 스토어 정보를 가져오는데 실패했습니다.", false))
            }
            subscriber.send(completion: .finished)
          }
        return AnyCancellable({})
      })
      .eraseToEffect()
    }
  )
}
