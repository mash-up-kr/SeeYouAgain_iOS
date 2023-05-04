//
//  UserDTO.swift
//  Models
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation
import UIKit

public struct UserDTO: Decodable, Equatable {
  public var id: Int
  public var name: String
  
  public init() {
    self.id = 1
    self.name = "Leanne Graham"
  }
}

#if DEBUG
public extension UserDTO {
  static let stub = UserDTO.init()
}
#endif
