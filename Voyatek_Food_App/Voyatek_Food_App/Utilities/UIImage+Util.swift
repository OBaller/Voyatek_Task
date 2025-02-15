//
//  UIImage+Util.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 14/02/2025.
//

import UIKit

public extension UIImage? {
    func original() -> UIImage {
        if let self = self {
            return self.withRenderingMode(.alwaysOriginal)
        }
        return UIImage()
    }
  
  static func convertBase64ToImage(base64String: String) -> Self {
    guard let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) else {
      return nil
    }
    return UIImage(data: imageData)
  }
}

extension UIImage {
  public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
    let maxRadius = min(size.width, size.height) / 2
    let cornerRadius: CGFloat
    if let radius = radius, radius > 0 && radius <= maxRadius {
      cornerRadius = radius
    } else {
      cornerRadius = maxRadius
    }
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    let rect = CGRect(origin: .zero, size: size)
    UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
    draw(in: rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
}
