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
  
  private init(
    saveCategory: @escaping (_ categories: [String]) -> Effect<SaveCategoryResponseDTO, Error>
  ) {
    self.saveCategory = saveCategory
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
    }
  )
}

#if DEBUG
extension CategoryService {
  public static let unimplemented = Self(
    saveCategory: XCTUnimplemented("\(Self.self).saveCategory")
  )
}
#endif
