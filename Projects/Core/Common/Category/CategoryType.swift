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
  case world = "세계"
  case culture = "생활/문화"
  case science = "IT/과학"
  
  public var uppercasedName: String {
    return String(describing: self).uppercased()
  }
  
  public init?(uppercasedName: String) {
    if uppercasedName == "POLITICS" {
      self = .politics
    } else if uppercasedName == "ECONOMIC" {
      self = .economic
    } else if uppercasedName == "SOCIETY" {
      self = .society
    } else if uppercasedName == "WORLD" {
      self = .world
    } else if uppercasedName == "CULTURE" {
      self = .culture
    } else if uppercasedName == "SCIENCE" {
      self = .science
    } else {
      return nil
    }
  }
  
  public var indexValue: Int {
    var indexValue = -1
    for (index, item) in Self.allCases.enumerated() {
      if item.rawValue == self.rawValue {
        indexValue = index
        break
      }
    }
    return indexValue
  }
}
