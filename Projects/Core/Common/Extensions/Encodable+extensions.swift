//
//  Encodable+extensions.swift
//  Common
//
//  Created by 김영균 on 2023/06/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

extension Encodable {    
  public var toDictionary: [String: Any] {
    guard let object = try? JSONEncoder().encode(self) else { return [:] }
    guard let dictionary = try? JSONSerialization.jsonObject(
      with: object,
      options: []
    ) as? [String: Any] else {
      return [:]
    }
    return dictionary
  }
}
