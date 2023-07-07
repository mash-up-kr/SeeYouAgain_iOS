//
//  DateType.swift
//  Common
//
//  Created by 안상희 on 2023/07/07.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct DateType: Equatable {
  public var year: Int
  public var month: Int
  
  public init(year: Int, month: Int) {
    self.year = year
    self.month = month
  }
}
