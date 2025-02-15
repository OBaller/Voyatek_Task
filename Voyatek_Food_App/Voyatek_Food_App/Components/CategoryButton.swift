//
//  CategoryButton.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 14/02/2025.
//

import UIKit

class CategoryButton: UIButton {
  override var isSelected: Bool {
    didSet {
      backgroundColor = isSelected ? .systemBlue : .systemGray6
      setTitleColor(isSelected ? .white : .black, for: .normal)
    }
  }
  
  init(title: String) {
    super.init(frame: .zero)
    setTitle(title, for: .normal)
    setTitleColor(.black, for: .normal)
    backgroundColor = .systemGray6
    layer.cornerRadius = 8
    setHeight(height: 30)
    contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class CustomImageButton: UIButton {
  
  init(imageName: String, title: String) {
    super.init(frame: .zero)
    setupButton(imageName: imageName, title: title)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupButton(imageName: String, title: String) {
    translatesAutoresizingMaskIntoConstraints = false
    
    // Set Image
    setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
    tintColor = .lightGray
    
    setTitle(title, for: .normal)
    setTitleColor(.lightGray, for: .normal)
    titleLabel?.font = .systemFont(ofSize: 16)
    titleLabel?.textAlignment = .center
    
    layer.borderWidth = 1
    layer.borderColor = UIColor.systemGray5.cgColor
    layer.cornerRadius = 8
    
    DispatchQueue.main.async {
      self.centerVertically(padding: 35)
    }
  }
}
