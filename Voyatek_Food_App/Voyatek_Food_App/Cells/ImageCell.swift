//
//  ImageCell.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 14/02/2025.
//

import UIKit

// MARK: - ImageCell
class ImageCell: UICollectionViewCell {
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 4
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let removeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "XCircle"), for: .normal)
    button.tintColor = .systemGray
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  var onRemove: (() -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.addSubview(imageView)
    contentView.addSubview(removeButton)
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 50),
      imageView.widthAnchor.constraint(equalToConstant: 50),
      removeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
      removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
      
      removeButton.heightAnchor.constraint(equalToConstant: 16),
      removeButton.widthAnchor.constraint(equalToConstant: 16),
    ])
    
    removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
  }
  
  func configure(with image: UIImage) {
    imageView.image = image
  }
  
  @objc private func removeTapped() {
    onRemove?()
  }
}
