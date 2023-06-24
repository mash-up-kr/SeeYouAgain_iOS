//
//  CategoryService.swift
//  Services
//
//  Created by GREEN on 2023/06/14.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Alamofire
import Common
import ComposableArchitecture
import Foundation
import Models

#if DEBUG
import XCTestDynamicOverlay
#endif

public struct CategoryService {
  public var saveCategory: (_ categories: [String]) -> Effect<SaveCategoryResponseDTO, Error>
  public var getAllCategories: () -> Effect<[CategoryType], Error>
  public var updateCategories: (_ categories: [String]) -> Effect<VoidResponse?, Error>
  
  private init(
    saveCategory: @escaping (_ categories: [String]) -> Effect<SaveCategoryResponseDTO, Error>,
    getAllCateogires: @escaping () -> Effect<[CategoryType], Error>,
    updateCategories: @escaping (_ categories: [String]) -> Effect<VoidResponse?, Error>
  ) {
    self.saveCategory = saveCategory
    self.getAllCategories = getAllCateogires
    self.updateCategories = updateCategories
  }
}

extension CategoryService {
  public static let live = Self(
    saveCategory: { categories in
      return Provider<CategoryAPI>
        .init()
        .request(
          CategoryAPI.saveCategory(categories: categories),
          type: SaveCategoryResponseDTO.self
        )
        .compactMap { $0 }
        .eraseToEffect()
    },
    getAllCateogires: {
      return Provider<CategoryAPI>
        .init()
        .request(
          CategoryAPI.getAllCategories,
          type: GetAllCategoriesResponseDTO.self
        )
        .compactMap{ $0 }
        .map { $0.categories.compactMap { CategoryType(uppercasedName: $0) }}
        .eraseToEffect()
    },
    updateCategories: { categories in
      return Provider<CategoryAPI>
        .init()
        .request(
          CategoryAPI.updateCategories(categories: categories),
          type: VoidResponse.self
        )
        .eraseToEffect()
    }
  )
}

#if DEBUG
extension CategoryService {
  public static let unimplemented = Self(
    saveCategory: XCTUnimplemented("\(Self.self).saveCategory"),
    getAllCateogires: XCTUnimplemented("\(Self.self).getAllCateogires"),
    updateCategories: XCTUnimplemented("\(Self.self).updateCategories")
  )
}
#endif
