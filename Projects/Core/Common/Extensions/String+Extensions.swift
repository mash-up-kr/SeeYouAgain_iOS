//
//  String+Extensions.swift
//  Core
//
//  Created by 안상희 on 2023/08/06.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

extension String {
  public func stringToDate() -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: self) ?? Date()
  }
}
