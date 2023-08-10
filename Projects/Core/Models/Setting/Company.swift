//
//  Company.swift
//  CoreKit
//
//  Created by 김영균 on 2023/08/10.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public enum Company: String, Equatable, CaseIterable {
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
}

public extension Company {
  var description: String {
    switch self {
    default:
      return "dlehdwjswk"
    }
  }
  
  var englishName: String {
    switch self {
    case .naver:
      return "NAVER"
    case .kakao:
      return "KAKAO"
    case .line:
      return "LINE"
    case .coupang:
      return "COUPANG"
    case .wooah:
      return "WOOAH"
    case .carrot:
      return "CARROT"
    case .toss:
      return "TOSS"
    case .samsung:
      return "SAMSUNG"
    case .hyundai:
      return "HYUNDAI"
    case .cj:
      return "CJ"
    case .korea_elec:
      return "KOREA_ELEC"
    case .lg_elec:
      return "LG_ELEC"
    case .korea_gas:
      return "KOREA_GAS"
    case .sk_hynics:
      return "SK_HYNICS"
    }
  }
}
