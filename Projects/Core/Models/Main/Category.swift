//
//  Category.swift
//  CoreKit
//
//  Created by 김영균 on 2023/06/08.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct Category: Equatable {
  public var id: Int
  public var name: String
  public var isSelected: Bool
  
  public init(
    id: Int,
    name: String,
    isSelected: Bool
  ) {
    self.id = id
    self.name = name
    self.isSelected = isSelected
  }
}

public extension Category {
  static let stub = [
    Category(id: 1, name: "정치", isSelected: true),
    Category(id: 2, name: "경제", isSelected: false),
    Category(id: 3, name: "사회", isSelected: true),
    Category(id: 4, name: "생활/문화", isSelected: false),
    Category(id: 5, name: "세계", isSelected: true),
    Category(id: 6, name: "IT/과학", isSelected: true),
    Category(id: 7, name: "연애", isSelected: false),
    Category(id: 8, name: "스포츠", isSelected: false),
  ]
}
