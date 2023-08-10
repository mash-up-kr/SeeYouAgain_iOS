//
//  CategoryType.swift
//  CoreKit
//
//  Created by GREEN on 2023/06/03.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public enum CategoryType: String, CaseIterable {
  // MARK: 일반 카테고리
  case politics = "정치"
  case economic = "경제"
  case society = "사회"
  case world = "세계"
  case culture = "생활/문화"
  case science = "IT/과학"
  // MARK: 관심 기업 카테고리
  case naver = "네이버"
  case kakao = "카카오"
  case line = "라인"
  case coupang = "쿠팡"
  case wooah = "우아한형제들"
  case carrot = "당근마켓"
  case toss = "비바리퍼블리카"
  case samsung = "삼성전자"
  case hyundai = "현대자동차"
  case cj = "CJ제일제당"
  case korea_elec = "한국전력공사"
  case lg_elec = "LG전자"
  case korea_gas = "한국가스공사"
  case sk_hynics = "SK하이닉스"
  
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
    } else if uppercasedName == "NAVER" {
      self = .naver
    } else if uppercasedName == "KAKAO" {
      self = .kakao
    } else if uppercasedName == "LINE" {
      self = .line
    } else if uppercasedName == "COUPANG" {
      self = .coupang
    } else if uppercasedName == "WOOAH" {
      self = .wooah
    } else if uppercasedName == "CARROT" {
      self = .carrot
    } else if uppercasedName == "TOSS" {
      self = .toss
    } else if uppercasedName == "SAMSUNG" {
      self = .samsung
    } else if uppercasedName == "HYUNDAI" {
      self = .hyundai
    } else if uppercasedName == "CJ" {
      self = .cj
    } else if uppercasedName == "KOREA_ELEC" {
      self = .korea_elec
    } else if uppercasedName == "LG_ELEC" {
      self = .lg_elec
    } else if uppercasedName == "KOREA_GAS" {
      self = .korea_gas
    } else if uppercasedName == "SK_HYNICS" {
      self = .sk_hynics
    }
    else {
      return nil
    }
  }
  
  public var indexValue: Int? {
    Self.allCases.firstIndex(where: { $0.rawValue == self.rawValue })
  }
  
  public static func compare(_ left: CategoryType, _ right: CategoryType) -> Bool {
    if let leftIndex = left.indexValue, let rightIndex = right.indexValue {
      return leftIndex < rightIndex
    }
    return false
  }
  
  public static var basicCategoires: [CategoryType] {
    return [.politics, .economic, .society, .world, .culture, .science]
  }
  
  public static var companyCategories: [CategoryType] {
    return [
      .carrot, .cj, .coupang, .hyundai, .kakao, .korea_elec,
      .korea_gas, .lg_elec, .line, .naver, .samsung, .sk_hynics, .toss, .wooah
    ]
  }
}
