//
//  CustomTextField.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 15/02/2025.
//

import UIKit

public class CustomTextfield: UITextField {
  
  // MARK: - Initializers
  
  convenience init(_ placeholder: String) {
    self.init(frame: .zero)
    self.placeholder = placeholder
  }
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    delegate = self
    setHeight(height: 55)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public Methods
  
  static func searchField(_ placeholder: String) -> CustomTextfield {
    let textField = CustomTextfield(placeholder)
    textField.backgroundColor = UIColor.BBG.brandWhite
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.BBG.bzInactive.cgColor
    textField.addSearch()
    return textField
  }
  
  func addChevronRight() {
    let view = UIView()
    view.setDimensions(height: 15, width: 28)
    let imageView = UIImageView(image: UIImage(named: "chevron.right2"))
    imageView.setDimensions(height: 15, width: 8)
    view.addSubview(imageView)
    imageView.newAnchor(top: view.topAnchor, right: view.rightAnchor, paddingRight: 18)
    rightView = view
    rightViewMode = .always
  }
  
  func addChevronDown() {
    let view = UIView()
    view.setDimensions(height: 15, width: 28)
    let imageView = UIImageView(image: UIImage(named: "chevron.down"))
    imageView.setDimensions(height: 8, width: 15)
    view.addSubview(imageView)
    imageView.newAnchor(top: view.topAnchor, right: view.rightAnchor, paddingRight: 18)
    rightView = view
    rightViewMode = .always
  }
  
  func addRightImage(named imageName: String, size: CGSize) {
    let view = UIView(frame: CGRect(x: frame.width - size.width - 8, y: 0, width: size.width + 8, height: 30))
    let imageView = UIImageView(image: UIImage(named: imageName))
    imageView.contentMode = .scaleAspectFit
    imageView.frame = CGRect(x: 0, y: (30 - size.height) / 2, width: size.width, height: size.height)
    view.addSubview(imageView)
    rightView = view
    rightViewMode = .always
  }
  
  func addDropdown() {
    let buttonView = createButtonImageView(buttonImage: dropdownImages[0] ?? UIImage())
    buttonView.addTarget(self, action: #selector(buttonPressed), for: .primaryActionTriggered)
    buttonView.tag = 1
    rightView = buttonView
    rightViewMode = .always
    clipsToBounds = true
  }
  
  func handleDropdownToggle() {
    guard let dropdownButton = viewWithTag(1) as? UIButton else { return }
    let currentImage = dropdownButton.image(for: .normal)
    guard let currentIndex = dropdownImages.firstIndex(of: currentImage) else { return }
    print("currentIndex", currentIndex)
    let nextIndex = ((currentIndex) + 1) % dropdownImages.count
    dropdownButton.setImage(dropdownImages[nextIndex], for: .normal)
  }
  
  @objc func buttonPressed() {
    self.becomeFirstResponder()
  }
  
  // MARK: - Private Methods
  
  private func createButtonImageView(buttonImage: UIImage) -> UIButton {
    let button = UIButton(type: .system)
    button.backgroundColor = .BBG.primary
    button.setDimensions(height: 55, width: 80)
    button.setImage(buttonImage, for: .normal)
    button.imageView?.setDimensions(height: 7, width: 12)
    return button
  }
  
  private func addSearch() {
    var imageView = UIImageView()
    if #available(iOS 13.0, *) {
      imageView = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withTintColor(.BBG.textPrimary, renderingMode: .alwaysOriginal))
    }
    imageView.setDimensions(height: 17, width: 17)
    imageView.isUserInteractionEnabled = false
    let containerView = UIView()
    containerView.setDimensions(height: 55, width: 40)
    
    containerView.addSubview(imageView)
    imageView.centerYInSuperview()
    imageView.newAnchor(left: containerView.leftAnchor)
    rightView = containerView
    rightViewMode = .always
  }
  
  private let dropdownImages = [
    UIImage(named: "dropdown")?.withRenderingMode(.alwaysOriginal),
    UIImage(named: "dropup")?.withRenderingMode(.alwaysOriginal)
  ]
}

// MARK: - UITextFieldDelegate

extension CustomTextfield: UITextFieldDelegate {
  public func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.BBG.primary.cgColor
    handleDropdownToggle()
  }
  
  public func textFieldDidEndEditing(_ textField: UITextField) {
    textField.layer.borderWidth = 0
    handleDropdownToggle()
  }
}
