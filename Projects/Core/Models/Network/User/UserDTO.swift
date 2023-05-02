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
  
  public init() { }
}

#if DEBUG
public extension UserDTO {
  static let stub = UserDTO.init()
}
#endif
