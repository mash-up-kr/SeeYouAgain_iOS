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
  case woowabros = "우아한형제들"
  case daangn = "당근마켓"
  case vibariperublika = "비바리퍼블리카"
  case samsungElectronics = "삼성전자"
  case hyundaiMotor = "현대자동차"
  case cjCheilJedang = "CJ제일제당"
  case koreaElectricPower = "한국전력공사"
  case lgElectronics = "LG전자"
  case koreaGasCorporation = "한국가스공사"
  case skHynix = "SK하이닉스"
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
    case .woowabros:
      return "WOOAH"
    case .daangn:
      return "CARROT"
    case .vibariperublika:
      return "TOSS"
    case .samsungElectronics:
      return "SAMSUNG"
    case .hyundaiMotor:
      return "HYUNDAI"
    case .cjCheilJedang:
      return "CJ"
    case .koreaElectricPower:
      return "KOREA_ELEC"
    case .lgElectronics:
      return "LG_ELEC"
    case .koreaGasCorporation:
      return "KOREA_GAS"
    case .skHynix:
      return "SK_HYNICS"
    }
  }
}
