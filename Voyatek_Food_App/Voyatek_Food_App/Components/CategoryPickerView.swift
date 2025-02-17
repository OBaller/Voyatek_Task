//
//  CategoryPickerView.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 16/02/2025.
//

import UIKit

class CategoryPickerView: UIView {
  
  private var categories: [Category] = [] {
    didSet {
      DispatchQueue.main.async {
        self.pickerView.reloadAllComponents()
      }
    }
  }
  
  private var selectedCategory: Category? {
    didSet {
      DispatchQueue.main.async {
        self.selectedValueLabel.text = self.selectedCategory?.name ?? "Select Category"
        self.selectedValueLabel.textColor = self.selectedCategory == nil ? .placeholderText : .lightGray
        self.delegate?.categoryPickerView(self, didSelect: self.selectedCategory)
      }
    }
  }
  
  weak var delegate: CategoryPickerViewDelegate?
  
  // UI Components
  private let categoryLabel: UILabel = {
    let label = UILabel()
    label.text = "Category"
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.textColor = .darkGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.systemGray4.cgColor
    view.layer.cornerRadius = 8
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let selectedValueLabel: UILabel = {
    let label = UILabel()
    label.text = "Select category"
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.textColor = .placeholderText
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let chevronImageView: UIImageView = {
    let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
    let image = UIImage(systemName: "chevron.down", withConfiguration: config)
    let imageView = UIImageView(image: image)
    imageView.tintColor = .black
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private lazy var pickerView: UIPickerView = {
    let picker = UIPickerView()
    picker.delegate = self
    picker.dataSource = self
    return picker
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupGestures()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    addSubview(categoryLabel)
    addSubview(containerView)
    containerView.addSubview(selectedValueLabel)
    containerView.addSubview(chevronImageView)
    
    NSLayoutConstraint.activate([
      categoryLabel.topAnchor.constraint(equalTo: topAnchor),
      categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      
      containerView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
      containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      containerView.heightAnchor.constraint(equalToConstant: 50),
      containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      selectedValueLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      selectedValueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      selectedValueLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
      
      chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
      chevronImageView.widthAnchor.constraint(equalToConstant: 16),
      chevronImageView.heightAnchor.constraint(equalToConstant: 16)
    ])
  }
  
  private func setupGestures() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    containerView.addGestureRecognizer(tapGesture)
    containerView.isUserInteractionEnabled = true
  }
  
  private func animateBorder(to color: UIColor) {
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.2) {
        self.containerView.layer.borderColor = color.cgColor
      }
    }
  }
  
  @objc private func handleTap() {
    animateBorder(to: .systemBlue)
    
    let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
    
    pickerView.frame = CGRect(x: 0, y: 0, width: alertController.view.frame.width - 16, height: 200)
    alertController.view.addSubview(pickerView)
    
    let selectAction = UIAlertAction(title: "Select", style: .default) { [weak self] _ in
      DispatchQueue.main.async {
        let selectedRow = self?.pickerView.selectedRow(inComponent: 0) ?? 0
        self?.selectedCategory = self?.categories[selectedRow]
        self?.animateBorder(to: .lightGray)
      }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
      self?.animateBorder(to: .lightGray)
    }
    
    alertController.addAction(selectAction)
    alertController.addAction(cancelAction)
    
    DispatchQueue.main.async {
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
         let viewController = windowScene.windows.first?.rootViewController {
        viewController.present(alertController, animated: true)
      }
    }
  }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension CategoryPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return categories.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return categories[row].name
  }
}

// MARK: - Fetch Categories
extension CategoryPickerView {
  func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
    NetworkManager.shared.fetchCategories { [weak self] result in
      switch result {
        case .success(let response):
          DispatchQueue.main.async {
            self?.categories = response.data
            completion(.success(response.data))
          }
        case .failure(let error):
          DispatchQueue.main.async {
            completion(.failure(error))
          }
      }
    }
  }
  
  var category: Category? {
    get { return selectedCategory }
    set { selectedCategory = newValue }
  }
}

// MARK: - Define Delegate Protocol
protocol CategoryPickerViewDelegate: AnyObject {
  func categoryPickerView(_ pickerView: CategoryPickerView, didSelect category: Category?)
}
