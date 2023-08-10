//
//  ChangeModeRequestDTO.swift
//  CoreKit
//
//  Created by 김영균 on 2023/08/10.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

public struct ChangeModeRequestDTO: Encodable {
  public let showMode: [String]
  
  public init(showMode: [String]) {
    self.showMode = showMode
  }
}
