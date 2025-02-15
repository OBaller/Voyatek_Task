//
//  InputView.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 14/02/2025.
//

import UIKit

class InputView: UIView, UITextFieldDelegate {
  
  private let label = UILabel()
  let textField = UITextField()
  
  private let defaultBorderColor = UIColor.lightGray.cgColor
  private let activeBorderColor = UIColor.systemBlue.cgColor
  
  init(labelText: String, placeholder: String) {
    super.init(frame: .zero)
    setupUI(labelText: labelText, placeholder: placeholder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI(labelText: String, placeholder: String) {
    label.text = labelText
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.textColor = .darkGray
    
    textField.placeholder = placeholder
    textField.borderStyle = .none
    textField.layer.borderWidth = 0.5
    textField.layer.borderColor = defaultBorderColor
    textField.layer.cornerRadius = 8
    textField.textColor = .systemGray
    textField.font = .systemFont(ofSize: 12, weight: .regular)
    textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 50))
    textField.leftView = paddingView
    textField.leftViewMode = .always
    
    textField.delegate = self
    
    addSubview(label)
    addSubview(textField)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: topAnchor),
      label.leadingAnchor.constraint(equalTo: leadingAnchor),
      label.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
      textField.leadingAnchor.constraint(equalTo: leadingAnchor),
      textField.trailingAnchor.constraint(equalTo: trailingAnchor),
      textField.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  // MARK: - UITextFieldDelegate Methods
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.layer.borderColor = activeBorderColor
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.layer.borderColor = defaultBorderColor
  }
}
