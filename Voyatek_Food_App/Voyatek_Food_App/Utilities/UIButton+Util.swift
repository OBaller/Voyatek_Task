//
//  UIButton+Util.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 14/02/2025.
//

import Foundation
//
//  UIButton+Util.swift
//  Business Zone UIKit
//
//  Created by LAIDSTALL on 27/01/2023.
//

import UIKit

public extension UIButton {
  convenience init(text: String, textColor: UIColor? = nil, bgColor: UIColor? = nil) {
    self.init(type: .custom)
    setTitle(text, for: .normal)
    titleLabel?.text = text
    //      titleLabel?.font = .BBG.paragraphSmall.font
    setTitleColor(textColor, for: .normal)
    //    setHeight(height: 55)
    backgroundColor = bgColor
  }
  
  convenience init(image: UIImage?) {
    self.init(frame: .zero)
    setImage(image, for: .normal)
  }
  
  func setButtonImage(_ normalImage: String, selectedImage: String? = nil) {
    setImage(UIImage(named: normalImage), for: .normal)
    if let selectedImage = selectedImage {
      setImage(UIImage(named: selectedImage), for: .selected)
    }
  }
  
  func setButtonTitle(_ normal: String?, _ selected: String?) {
    setTitle(normal, for: .normal)
    setTitle(selected, for: .selected)
  }
  
  
  
  func disable() {
    self.isEnabled = false
    self.backgroundColor = .lightGray
    self.setTitleColor(.white.withAlphaComponent(0.6), for: .disabled)
  }
  
  func enable() {
    self.isEnabled = true
    self.backgroundColor = .systemBlue
  }
  
  func createCustomButton(imageName: String, title: String) -> UIButton {
      let button = UIButton(type: .system)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
      button.tintColor = .lightGray
      button.setTitle(title, for: .normal)
      button.titleLabel?.font = .systemFont(ofSize: 16)
      button.layer.borderWidth = 1
      button.layer.borderColor = UIColor.systemGray5.cgColor
      button.layer.cornerRadius = 8
      button.centerVertically(padding: 35)
      return button
  }

}


extension UIButton {
  func centerVertically(padding: CGFloat = 8.0) {
    guard let imageSize = self.imageView?.image?.size,
          let titleLabel = self.titleLabel,
          let titleText = titleLabel.text else { return }
    
    let titleSize = titleText.size(withAttributes: [
      NSAttributedString.Key.font: titleLabel.font ?? .systemFont(ofSize: 16)
    ])
    
    let totalHeight = imageSize.height + titleSize.height + padding
    
    let imageOffset = (titleSize.height + padding) / 2
    let titleOffset = (imageSize.height + padding) / 2
    
    imageEdgeInsets = UIEdgeInsets(
      top: -(totalHeight - imageSize.height - titleSize.height),
      left: 0,
      bottom: 0,
      right: -titleSize.width
    )
    
    titleEdgeInsets = UIEdgeInsets(
      top: 0,
      left: -imageSize.width,
      bottom: -(totalHeight - titleSize.height - imageSize.height),
      right: 0
    )
  }
}
