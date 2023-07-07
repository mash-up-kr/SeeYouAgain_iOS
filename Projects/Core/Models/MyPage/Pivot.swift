//
//  Pivot.swift
//  Models
//
//  Created by 안상희 on 2023/07/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public enum Pivot: String, Encodable {
  case desc
  case asc

  enum CodingKeys: String, CodingKey {
    case desc = "DESC"
    case asc = "ASC"
  }
}
