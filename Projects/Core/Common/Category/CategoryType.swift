//
//  CategoryType.swift
//  CoreKit
//
//  Created by GREEN on 2023/06/03.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public enum CategoryType: String, CaseIterable {
  case politics = "정치"
  case economic = "경제"
  case society = "사회"
  case culture = "생활/문화"
  case world = "세계"
  case science = "IT/과학"
  
  public var uppercasedName: String {
    return String(describing: self).uppercased()
  }
}
