//
//  FoodTableViewCell.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 14/02/2025.
//

import UIKit

class FoodTableViewCell: UITableViewCell {
  // MARK: - Properties
  
  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemBackground
    view.layer.cornerRadius = 12
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowRadius = 4
    view.layer.shadowOpacity = 0.1
    view.layer.borderColor = UIColor.BBG.bzInactive.cgColor
    view.layer.borderWidth = 0.3
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let mainImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 4
    imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    imageView.backgroundColor = .systemGray6
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let caloriesImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "Fire")
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    return imageView
  }()
  
  private let caloriesStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 2
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let caloriesLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.textColor = .systemGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12)
    label.textColor = .systemGray
    label.numberOfLines = 2
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let favoriteButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "heart"), for: .normal)
    button.tintColor = .systemGray
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let tagsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  
  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 12).cgPath
  }
  
  // MARK: - Setup UI
  private func setupUI() {
    selectionStyle = .none
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    
    contentView.addSubview(containerView)
    containerView.addSubview(mainImageView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(caloriesStackView)
    containerView.addSubview(descriptionLabel)
    containerView.addSubview(favoriteButton)
    containerView.addSubview(tagsStackView)
    
    caloriesStackView.addArrangedSubview(caloriesImageView)
    caloriesStackView.addArrangedSubview(caloriesLabel)
    
    
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      
      mainImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
      mainImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      mainImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      mainImageView.heightAnchor.constraint(equalToConstant: 137),
      
      titleLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 12),
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
      
      caloriesStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
      caloriesStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
      
      favoriteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
      favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
      favoriteButton.widthAnchor.constraint(equalToConstant: 24),
      favoriteButton.heightAnchor.constraint(equalToConstant: 24),
      
      descriptionLabel.topAnchor.constraint(equalTo: caloriesLabel.bottomAnchor, constant: 8),
      descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
      
      tagsStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
      tagsStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      tagsStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
      tagsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
      
    ])
    
    favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
  }
  
  // MARK: - Configure Cell
  func configure(with food: Food) {
    titleLabel.text = food.name
    caloriesLabel.text = "\(food.calories) Calories"
    descriptionLabel.text = food.description
    
    // Load first image or set to nil if none available
    if let firstImageName = food.imageURLs.first {
      mainImageView.image = UIImage(named: firstImageName)
    } else {
      mainImageView.image = nil
    }
    
    // Clear old tags before adding new ones (to handle cell reuse)
    tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
    for tag in food.tags {
      let tagView = TagView(title: tag) // Assuming you have a TagView component
      tagsStackView.addArrangedSubview(tagView)
    }
  }
  
  
  // MARK: - Actions
  @objc private func favoriteButtonTapped() {
    let isFavorited = favoriteButton.currentImage == UIImage(systemName: "heart")
    
    let newImage = isFavorited ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    favoriteButton.setImage(newImage, for: .normal)
    
    // Change tint color when favorited
    favoriteButton.tintColor = isFavorited ? .red : .gray
    
    // Add haptic feedback
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
  }
  
  
  override func prepareForReuse() {
    super.prepareForReuse()
    mainImageView.image = nil
    favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
    tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
  }
}
