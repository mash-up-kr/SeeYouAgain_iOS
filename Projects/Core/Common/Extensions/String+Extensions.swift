//
//  String+Extensions.swift
//  Models
//
//  Created by 안상희 on 2023/06/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

extension String {
  func toDate() -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    
    if let date = dateFormatter.date(from: self) {
      return date
    }
    return Date()
  }
}
