//
//  SavedNewsList.swift
//  Models
//
//  Created by 안상희 on 2023/07/04.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct SavedNewsList {
  public let month: String
  public let savedNewsCount: Int
  public let newsList: [News]
}
