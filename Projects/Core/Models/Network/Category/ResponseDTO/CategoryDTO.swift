//
//  CategoryDTO.swift
//  Models
//
//  Created by GREEN on 2023/06/14.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//


// MARK: - 추후 API 필드 정리 후 변경 필요
public struct CategoryDTO: Decodable {
  let categories: [String]
  
  public init(categories: [String]) {
    self.categories = categories
  }
}
