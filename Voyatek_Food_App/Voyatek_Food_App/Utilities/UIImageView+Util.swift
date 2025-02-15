//
//  UIImageView+Util.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 14/02/2025.
//

import UIKit

public extension UIImageView {
  convenience init(named imageName: String) {
    self.init()
    image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
    clipsToBounds = true
    contentMode = .scaleAspectFit
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  convenience init(systemName imageName: String, tint: UIColor = .systemBlue) {
    self.init()
    if #available(iOS 13.0, *) {
      image = UIImage(systemName: imageName)?.withTintColor(tint, renderingMode: .alwaysOriginal)
    }
    clipsToBounds = true
    contentMode = .scaleAspectFit
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  static func custom() -> UIImageView {
    let iv = UIImageView()
    iv.clipsToBounds = true
    iv.contentMode = .scaleAspectFit
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }
  
}
