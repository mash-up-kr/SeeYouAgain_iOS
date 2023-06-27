//
//  Array+extensions.swift
//  Common
//
//  Created by lina on 2023/06/15.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import Foundation

extension Array {
  public subscript(safe index: Int) -> Element? {
    get {
      indices ~= index ? self[index] : nil
    }
    set(newValue) {
      if let newValue = newValue, indices.contains(index) {
        self[index] = newValue
      }
    }
  }
}
