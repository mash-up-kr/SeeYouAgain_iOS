//
//  DateFormatter+extensions.swift
//  Common
//
//  Created by 리나 on 2023/06/26.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

extension DateFormatter {
  public static let hotKeywordDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateFormatter
  }()
}
