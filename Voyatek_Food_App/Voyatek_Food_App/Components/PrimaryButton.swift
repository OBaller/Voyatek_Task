//
//  PrimaryButton.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 15/02/2025.
//

import UIKit
public class PrimaryButton: UIButton {
  public override var isEnabled: Bool {
    didSet {
      updateBackgroundColor()
    }
  }
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setTitle("sign in", for: .normal)
    layer.borderWidth = 0
    translatesAutoresizingMaskIntoConstraints = false
    clipsToBounds = true
    //        titleLabel?.font = .BBG.paragraph.font
    layer.cornerRadius = 10
    heightAnchor.constraint(equalToConstant: 50).isActive = true
    backgroundColor = .lightGray
    updateBackgroundColor()
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func updateBackgroundColor() {
    if isEnabled {
      backgroundColor = .systemBlue
    } else {
      backgroundColor = UIColor(red: 231/255, green: 240/255, blue: 255/255, alpha: 1)
    }
  }
}
