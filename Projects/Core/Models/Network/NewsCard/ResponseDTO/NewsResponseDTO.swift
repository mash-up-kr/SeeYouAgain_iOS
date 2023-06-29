//
//  NewsResponseDTO.swift
//  Models
//
//  Created by 김영균 on 2023/06/28.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct NewsResponseDTO: Decodable {
  public let id: Int
  public let title: String
  public let thumbnailImageUrl: String
  public let newsLink: String
  public let press: String
  public let writtenDateTime: String
  public let type: String
}
