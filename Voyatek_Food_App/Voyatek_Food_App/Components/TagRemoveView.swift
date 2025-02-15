//
//  TagRemoveView.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 14/02/2025.
//

import UIKit
import UIKit

class TagRemoveView: UIView {
  
  private let label = UILabel()
  private let removeButton = UIButton(type: .system)
  private var onRemove: (() -> Void)?
  
  init(text: String, onRemove: @escaping () -> Void) {
    super.init(frame: .zero)
    self.onRemove = onRemove
    setupUI(text: text)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI(text: String) {
    backgroundColor = UIColor(red: 240/255, green: 242/255, blue: 245/255, alpha: 1)
    layer.cornerRadius = 8
    layer.masksToBounds = true
    
    label.text = text
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.textColor = .black
    
    removeButton.setImage(UIImage(named: "CancelIcon"), for: .normal)
    removeButton.tintColor = .gray
    removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
    
    let stackView = UIStackView(arrangedSubviews: [label, removeButton])
    stackView.axis = .horizontal
    stackView.spacing = 2
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
    ])
  }
  
  @objc private func removeTapped() {
    onRemove?()
  }
}
