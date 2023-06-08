//
//  UserDefaultsService.swift
//  CoreKit
//
//  Created by GREEN on 2023/06/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Combine
import CombineExt
import ComposableArchitecture
import Foundation

public struct UserDefaultsService {
  public let save: (Bool) -> Effect<Void, Never>
  public let load: () -> Effect<Bool, Never>
  
  private init(
    save: @escaping (Bool) -> Effect<Void, Never>,
    load: @escaping () -> Effect<Bool, Never>
  ) {
    self.save = save
    self.load = load
  }
}

public extension UserDefaultsService {
  static var live = Self.init(
    save: { value in
      return Publishers.Create<Void, Never>(factory: { subscriber -> Cancellable in
        subscriber.send(UserDefaults.standard.set(value, forKey: "registered"))
        subscriber.send(completion: .finished)
        return AnyCancellable({})
      })
      .eraseToEffect()
    },
    load: {
      return Publishers.Create<Bool, Never>(factory: { subscriber -> Cancellable in
        subscriber.send(UserDefaults.standard.bool(forKey: "registered"))
        subscriber.send(completion: .finished)
        return AnyCancellable({})
      })
      .eraseToEffect()
    }
  )
}
