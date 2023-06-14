//
//  SaveCategoryDTO.swift
//  Models
//
//  Created by GREEN on 2023/06/14.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

// MARK: - 추후 카테고리 저장에 관한 API 필드 추가 시 변경 예정
public struct SaveCategoryDTO: Encodable {
  let categoryNames: [String]
  
  public init(categoryNames: [String]) {
    self.categoryNames = categoryNames
  }
}
