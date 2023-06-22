//
//  Date+extensions.swift
//  Common
//
//  Created by 김영균 on 2023/06/22.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

extension Date {
  public func toFormattedString(format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
}
