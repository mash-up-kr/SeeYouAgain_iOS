//
//  UIColor+extensions.swift
//  DesignSystem
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import UIKit

extension UIColor {
  public convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")

    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }

  public convenience init(rgb: Int) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF
    )
  }

  public func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
    return adjust(by: abs(percentage))
  }

  public func darker(by percentage: CGFloat = 30.0) -> UIColor? {
    return adjust(by: -1 * abs(percentage))
  }

  public func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
      return UIColor(
        red: min(red + percentage / 100, 1.0),
        green: min(green + percentage / 100, 1.0),
        blue: min(blue + percentage / 100, 1.0),
        alpha: alpha)
    } else {
      return nil
    }
  }
}

extension UIColor {
  public var rgba: (red: Int, green: Int, blue: Int, alpha: Double) {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    return (
      Int(red * 255 + 0.5),
      Int(green * 255 + 0.5),
      Int(blue * 255 + 0.5),
      Double(alpha)
    )
  }
}
