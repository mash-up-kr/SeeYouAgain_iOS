//
//  AllNewsCardReponseDTO.swift
//  Core
//
//  Created by 김영균 on 2023/08/10.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct AllNewsCardReponseDTO: Decodable {
  public let homeTitle: String
  public let newsCards: [NewsCardsResponseDTO]
}