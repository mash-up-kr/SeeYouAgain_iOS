//
//  UserDTO.swift
//  Models
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct UserDTO: Decodable, Equatable {
  public var id: Int
  public var name: String
}

#if DEBUG
public extension UserDTO {
  static let stub = UserDTO.init(id: 1, name: "Leanne Graham")
}
#endif
