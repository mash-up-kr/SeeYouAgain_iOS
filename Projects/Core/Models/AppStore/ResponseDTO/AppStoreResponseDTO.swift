//
//  AppStoreResponseDTO.swift
//  CoreKit
//
//  Created by GREEN on 2023/06/19.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct AppStoreResponseDTO: Decodable {
  public let results: [AppStoreResult]
}

public struct AppStoreResult: Decodable {
  public let version: String
}
