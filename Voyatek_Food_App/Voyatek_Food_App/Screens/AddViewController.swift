//
//  AddViewController.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 14/02/2025.
//

import UIKit

import UIKit
import PhotosUI

class AddViewController: UIViewController {
  // MARK: - Properties
  private var imagesCollectionViewHeightConstraint: NSLayoutConstraint!
  private var selectedImages: [UIImage] = [] {
    didSet {
      imagesCollectionView.isHidden = selectedImages.isEmpty
      imagesCollectionViewHeightConstraint.constant = selectedImages.isEmpty ? 0 : 80
      imagesCollectionView.reloadData()
      UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
      }
    }
  }
  
  
  private var tags: [String] = []
  
  // MARK: - UI Components
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.alwaysBounceVertical = true
    scrollView.showsVerticalScrollIndicator = false
    return scrollView
  }()
  
  private let contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let imageOptionsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 16
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.setHeight(height: 90)
    return stackView
  }()
  
  private lazy var takePhotoButton = CustomImageButton(imageName: "CameraIcon", title: "Take photo")
  private lazy var uploadButton = CustomImageButton(imageName: "UploadSimple", title: "Upload")
  
  
  private let imagesCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 50, height: 50)
    layout.minimumInteritemSpacing = 8
    layout.minimumLineSpacing = 8
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.showsHorizontalScrollIndicator = true
    collectionView.alwaysBounceHorizontal = true
    return collectionView
  }()
  
  
  private let nameField: InputView = {
    let field = InputView(labelText: "Name", placeholder: "Enter food name")
    field.translatesAutoresizingMaskIntoConstraints = false
    return field
  }()
  
  private let descriptionView: DescriptionInputView = {
    let view = DescriptionInputView(labelText: "Description", placeholder: "Enter food description")
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  
  private let categoryView: InputView = {
    let view = InputView(labelText: "Category", placeholder: "Dawn Delicacies")
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textField.isEnabled = false
    return view
  }()
  
  private let caloriesView: InputView = {
    let view = InputView(labelText: "Calories", placeholder: "Enter number of calories")
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textField.keyboardType = .numberPad
    return view
  }()
  
  private let tagsView: InputView = {
    let view = InputView(labelText: "Tags", placeholder: "Add a tag")
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let tagsInfo: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 10, weight: .thin)
    label.text = "Press enter once you've typed a tag"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let tagsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.alignment = .leading
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let addFoodButton: PrimaryButton = {
    let button = PrimaryButton()
    button.setTitle("Add food", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
    button.setTitleColor(.lightGray, for: .normal)
    
    button.isEnabled = false
    return button
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupConstraints()
    setupActions()
    tagsView.textField.delegate = self
    
  }
  
  // MARK: - Setup
  private func setupUI() {
    view.backgroundColor = .systemBackground
    navigationItem.title = "Add new food"
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "chevron.left"),
      style: .plain,
      target: self,
      action: #selector(backButtonTapped)
    )
    
    imagesCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
    imagesCollectionView.delegate = self
    imagesCollectionView.dataSource = self
    
    tagsView.textField.delegate = self
    tagsView.textField.returnKeyType = .done
  }
  
  private func setupConstraints() {
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    
    contentView.addSubview(imageOptionsStackView)
    contentView.addSubview(imagesCollectionView)
    contentView.addSubview(nameField)
    contentView.addSubview(descriptionView)
    contentView.addSubview(categoryView)
    contentView.addSubview(caloriesView)
    contentView.addSubview(tagsView)
    contentView.addSubview(tagsStackView)
    contentView.addSubview(addFoodButton)
    contentView.addSubview(tagsInfo)
    
    let padding: CGFloat = 16
    imagesCollectionViewHeightConstraint = imagesCollectionView.heightAnchor.constraint(equalToConstant: 0)
    
    // ScrollView constraints
    scrollView.newAnchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.rightAnchor)
    
    // ContentView constraints
    contentView.newAnchor(top: scrollView.topAnchor,
                          left: scrollView.leftAnchor,
                          bottom: scrollView.bottomAnchor,
                          right: scrollView.rightAnchor)
    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    
    imageOptionsStackView.addArrangedSubview(takePhotoButton)
    imageOptionsStackView.addArrangedSubview(uploadButton)
    
    // Image options (Take Photo, Upload)
    imageOptionsStackView.newAnchor(top: contentView.topAnchor,
                                    left: contentView.leftAnchor,
                                    right: contentView.rightAnchor,
                                    paddingTop: padding,
                                    paddingLeft: padding,
                                    paddingRight: padding)
    
    // Images Collection View
    imagesCollectionView.newAnchor(top: imageOptionsStackView.bottomAnchor,
                                   left: contentView.leftAnchor,
                                   right: contentView.rightAnchor,
                                   paddingLeft: padding,
                                   paddingRight: padding)
    imagesCollectionViewHeightConstraint.isActive = true
    
    // Name Field
    nameField.newAnchor(top: imagesCollectionView.bottomAnchor,
                        left: contentView.leftAnchor,
                        right: contentView.rightAnchor,
                        paddingTop: 8,
                        paddingLeft: padding,
                        paddingRight: padding)
    
    // Description View
    descriptionView.newAnchor(top: nameField.bottomAnchor,
                              left: contentView.leftAnchor,
                              right: contentView.rightAnchor,
                              paddingTop: padding,
                              paddingLeft: padding,
                              paddingRight: padding)
    
    // Category View
    categoryView.newAnchor(top: descriptionView.bottomAnchor,
                           left: contentView.leftAnchor,
                           right: contentView.rightAnchor,
                           paddingTop: padding,
                           paddingLeft: padding,
                           paddingRight: padding)
    
    // Calories View
    caloriesView.newAnchor(top: categoryView.bottomAnchor,
                           left: contentView.leftAnchor,
                           right: contentView.rightAnchor,
                           paddingTop: padding,
                           paddingLeft: padding,
                           paddingRight: padding)
    
    // Tags View
    tagsView.newAnchor(top: caloriesView.bottomAnchor,
                       left: contentView.leftAnchor,
                       right: contentView.rightAnchor,
                       paddingTop: padding,
                       paddingLeft: padding,
                       paddingRight: padding)
    
    // Tags Stack View
    tagsStackView.newAnchor(top: tagsView.bottomAnchor,
                            left: contentView.leftAnchor,
                            paddingTop: 8,
                            paddingLeft: padding)
    
    tagsInfo.newAnchor(top: tagsStackView.bottomAnchor,
                            left: contentView.leftAnchor,
                            paddingTop: 4,
                            paddingLeft: padding)
    
    // Add Food Button
    addFoodButton.newAnchor(top: tagsStackView.bottomAnchor,
                            left: contentView.leftAnchor,
                            bottom: contentView.bottomAnchor, right: contentView.rightAnchor,
                            paddingTop: 40,
                            paddingLeft: padding,
                            paddingBottom: padding, paddingRight: padding)
  }
  
  
  
  
  private func setupActions() {
    takePhotoButton.addTarget(self, action: #selector(takePhotoTapped), for: .touchUpInside)
    uploadButton.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
    addFoodButton.addTarget(self, action: #selector(addFoodTapped), for: .touchUpInside)
  }
  
  // MARK: - Actions
  @objc private func backButtonTapped() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc private func takePhotoTapped() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.sourceType = .camera
    imagePickerController.delegate = self
    present(imagePickerController, animated: true)
  }
  
  @objc private func uploadTapped() {
    var config = PHPickerConfiguration()
    config.selectionLimit = 10 - selectedImages.count
    config.filter = .images
    
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = self
    present(picker, animated: true)
  }
  
  @objc private func addFoodTapped() {
    // Implement your save logic here
    print("Adding food...")
  }
  
  // MARK: - Tag Management
  private func addTag(_ tag: String) {
    guard !tag.isEmpty, !tags.contains(tag) else { return }
    
    tags.append(tag)
    
    let tagView = TagRemoveView(text: tag) { [weak self] in
      self?.removeTag(tag)
    }
    
    tagsStackView.addArrangedSubview(tagView)
    tagsView.textField.text = ""
  }
  
  private func removeTag(_ tag: String) {
    if let index = tags.firstIndex(of: tag) {
      tags.remove(at: index)
      tagsStackView.arrangedSubviews[index].removeFromSuperview()
    }
  }
}

// MARK: - UICollectionView
extension AddViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return selectedImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
    cell.configure(with: selectedImages[indexPath.row])
    cell.onRemove = { [weak self] in
      self?.selectedImages.remove(at: indexPath.row)
    }
    return cell
  }
}

// MARK: - UIImagePickerControllerDelegate
extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.originalImage] as? UIImage {
      selectedImages.append(image)
      imagesCollectionView.reloadData()
    }
    picker.dismiss(animated: true)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
  }
}

// MARK: - PHPickerViewControllerDelegate
extension AddViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    
    results.forEach { result in
      result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
        if let image = reading as? UIImage {
          DispatchQueue.main.async {
            self?.selectedImages.append(image)
            self?.imagesCollectionView.reloadData()
          }
        }
      }
    }
  }
}

// MARK: - UITextFieldDelegate
extension AddViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == tagsView.textField {
      if let text = textField.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty {
        addTag(text)
      }
    }
    textField.resignFirstResponder()
    return true
  }
}
