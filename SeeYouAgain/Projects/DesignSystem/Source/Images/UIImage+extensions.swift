//
//  UIImage+extensions.swift
//  DesignSystem
//
//  Created by GREEN on 2023/04/05.
//  Copyright © 2023 mashup.seeYouAgain. All rights reserved.
//

import UIKit

extension UIImage {
  public func withPadding(_ padding: UIEdgeInsets) -> UIImage {
    let origin = CGPoint(x: padding.left, y: padding.top)
    let sizeWithPadding = CGSize(
      width: padding.left + size.width + padding.right,
      height: padding.top + size.height + padding.bottom)

    UIGraphicsBeginImageContextWithOptions(sizeWithPadding, false, 0.0)
    draw(in: CGRect(origin: origin, size: size))

    let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext() ?? self
    UIGraphicsEndImageContext()

    return imageWithPadding
  }

  public func resize(scale: CGFloat) -> UIImage? {
    let transform = CGAffineTransform(scaleX: scale, y: scale)
    let size = self.size.applying(transform)
    UIGraphicsBeginImageContext(size)
    self.draw(in: CGRect(origin: .zero, size: size))
    let resultImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resultImage
  }

  public func resize(width desiredWidth: CGFloat) -> UIImage? {
    let originWidth = self.size.width
    let scale = desiredWidth / originWidth
    return resize(scale: scale)
  }

  public func shrink(width desiredWidth: CGFloat) -> UIImage? {
    if self.size.width <= desiredWidth {
      return self
    }
    return resize(width: desiredWidth)
  }

  public func toBase64() -> String? {
    guard let imageData = self.pngData() else { return nil }
    return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
  }
}

public extension Optional where Wrapped: UIImage {
  func unwrap() -> UIImage {
    guard let image = self else {
      fatalError("Unable to load image asset named, check again that the asset name is correct")
    }
    return image
  }
}
