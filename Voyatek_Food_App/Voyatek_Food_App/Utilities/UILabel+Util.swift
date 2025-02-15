//
//  UILabel+Util.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 14/02/2025.
//

import UIKit

extension UILabel {
  func padding(_ amount: CGFloat) {
    let insets = UIEdgeInsets(top: amount, left: amount, bottom: amount, right: amount)
    self.layer.cornerRadius = 8
    self.clipsToBounds = true
    self.drawText(in: self.frame.inset(by: insets))
  }
}

public extension UILabel {
  
  convenience init(text: String, size: CGFloat, isBold: Bool) {
    self.init()
    font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
    self.text = text
    textColor = UIColor.black
    numberOfLines = 0
    textAlignment = .center
    adjustsFontSizeToFitWidth = true
  }
  
  convenience init(text: String, size: CGFloat, alignment: NSTextAlignment, isBold: Bool) {
    self.init()
    font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
    self.text = text
    numberOfLines = 0
    textAlignment = alignment
    adjustsFontSizeToFitWidth = true
    self.textColor = UIColor.black
  }
  
  convenience init(text: String, size: CGFloat, textColor: UIColor, isBold: Bool) {
    self.init()
    font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
    self.text = text
    numberOfLines = 0
    textAlignment = .center
    adjustsFontSizeToFitWidth = true
    self.textColor = textColor
  }
  
  convenience init(text: String, size: CGFloat, textColor: UIColor, alignment: NSTextAlignment, isBold: Bool) {
    self.init()
    font = isBold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
    self.text = text
    numberOfLines = 0
    textAlignment = alignment
    adjustsFontSizeToFitWidth = true
    self.textColor = textColor
  }
  
  static func addHeaderLabel(withText text: String, size: CGFloat = 24, alignTo alignment: NSTextAlignment = .left) -> UILabel {
    return UILabel(text: text, size: size, alignment: alignment, isBold: true)
  }
  
  static func addPrimaryHeaderLabel(withText text: String, size: CGFloat = 24, alignTo alignment: NSTextAlignment = .left) -> UILabel {
    return UILabel(text: text, size: size, textColor: UIColor.systemBlue, alignment: alignment, isBold: true)
  }
  
  static func addSubtitleLabel(withText text: String, size: CGFloat = 16, textColor: UIColor = UIColor.darkGray, alignTo alignment: NSTextAlignment = .left) -> UILabel {
    let label = UILabel(text: text, size: size, textColor: textColor, alignment: alignment, isBold: false)
    return label
  }
  
  static func addErrorLabel(withText text: String, size: CGFloat = 16) -> UILabel {
    return UILabel(text: text, size: size, textColor: UIColor.red, alignment: .left, isBold: false)
  }
  
  func setLineHeight(spacing: CGFloat) {
    let attributedString = NSMutableAttributedString(string: self.text ?? "")
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = spacing
    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
    attributedText = attributedString
  }
  
  func underline() {
    if let textString = self.text {
      let attributedString = NSMutableAttributedString(string: textString)
      attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: textString.count))
      self.attributedText = attributedString
    }
  }
  static func addPrimaryLabel(withText text: String, size: CGFloat = 16) -> UILabel {
    let label = UILabel(text: text, size: size, textColor: UIColor.BBG.primary, alignment: .left, isBold: false)
    return label
  }
  
  static func addLabelWithImage(
    text: String,
    imageName: String,
    size: CGFloat = 16,
    textColor: UIColor = .black,
    spacing: CGFloat = 8,
    alignment: NSTextAlignment = .left,
    isBold: Bool = false
  ) -> UIView {
    let containerView = UIView()
    
    // Image View
    let imageView = UIImageView()
    imageView.image = UIImage(named: imageName)
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    // Label
    let label = UILabel(text: text, size: size, textColor: textColor, alignment: alignment, isBold: isBold)
    
    // Stack View
    let stackView = UIStackView(arrangedSubviews: [imageView, label])
    stackView.axis = .horizontal
    stackView.spacing = spacing
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])
    
    return containerView
  }
}

extension UILabel {
  @IBInspectable
  var letterSpace: CGFloat {
    get {
      if let currentLetterSpace = attributedText?.attribute(
        NSAttributedString.Key.kern, at: Int(self.letterSpace), effectiveRange: .none)
          as? CGFloat {
        return currentLetterSpace
      } else {
        return 0
      }
    }
    
    set {
      let attributedString = NSMutableAttributedString(string: text ?? "")
      attributedString.addAttribute(NSAttributedString.Key.kern, value: newValue, range: NSRange(location: 0, length: attributedString.length))
      attributedText = attributedString
    }
  }
}
