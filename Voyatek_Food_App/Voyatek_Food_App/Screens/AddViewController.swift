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
  var isForEditing = false
  var foodItem: FoodItem?
  private let viewModel = AddFoodViewModel()
  var categories: Category?
  var validTags: [Tag] = []
  private var tagsDictionary: [String: Int] = [:]
  private var selectedTagIDs: [Int] = []
  private var selectedTagNames: [String] = []
  
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
  
  let categoryView = CategoryPickerView()
  
  
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
    
    //    button.isEnabled = false
    return button
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupConstraints()
    setupActions()
    tagsView.textField.delegate = self
    if isForEditing, let food = foodItem {
      configureForEditing(with: food)
    }
    getCategories()
    
    setupBindings()
    viewModel.fetchTags()
    
  }
  
  private func setupBindings() {
    viewModel.onTagsUpdated = { [weak self] in
      guard let self = self else { return }
      self.tagsDictionary = self.viewModel.validTagsDictionary
      print("Updated tags: \(self.tagsDictionary)") // Debugging
    }
    
    viewModel.onError = { errorMessage in
      print("Error fetching tags: \(errorMessage)")
    }
  }
  
  private func getCategories() {
    categoryView.fetchCategories { [weak self] result in
      switch result {
        case .success(_):
          if self?.isForEditing == true, let category = self?.categories {
            self?.categoryView.category = category
          }
        case .failure(let error):
          print("Error fetching categories: \(error)")
      }
    }
  }
  
  private func configureForEditing(with food: FoodItem) {
    nameField.textField.text = food.name
    descriptionView.textView.text = food.description
    categoryView.category = food.category.toCategory()
    caloriesView.textField.text = String(food.calories)
    
    loadImagesFromURLs(food.foodImages.map { $0.imageURL })
    
    food.foodTags.forEach { tagName in
      addTagForEditing(tagName)
    }
    addFoodButton.setTitle("Update Food", for: .normal)
    addFoodButton.isEnabled = true
    addFoodButton.setTitleColor(.white, for: .normal)
    addFoodButton.backgroundColor = .systemBlue
  }
  
  private func addTagForEditing(_ tag: String) {
    tags.append(tag) // Display the tag as-is
    
    let tagView = TagRemoveView(text: tag) { [weak self] in
      self?.removeTag(tag)
    }
    tagsStackView.addArrangedSubview(tagView)
    
    if let tagID = tagsDictionary[tag] {
      selectedTagNames.append(tag)
      selectedTagIDs.append(tagID)
    } else {
      //      selectedTagNames.append(tag)
      //      let tempID = -abs(tag.hashValue)
      //      selectedTagIDs.append(tempID)
      
      //      print("Warning: Tag '\(tag)' not found in tagsDictionary. Using temporary ID: \(tempID)")
    }
  }
  
  
  private func loadImagesFromURLs(_ urls: [String]) {
    for urlString in urls {
      guard let url = URL(string: urlString) else {
        print("Invalid URL: \(urlString)")
        continue
      }
      
      URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
        guard let self = self, let data = data, let image = UIImage(data: data) else {
          print("Failed to load image from \(urlString): \(error?.localizedDescription ?? "Unknown error")")
          return
        }
        
        DispatchQueue.main.async {
          self.selectedImages.append(image)
          self.imagesCollectionView.reloadData()
        }
      }.resume()
    }
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
    guard let name = nameField.textField.text, !name.isEmpty,
          let description = descriptionView.textView.text, !description.isEmpty,
          let categoryId = categoryView.category?.id,
          let caloriesText = caloriesView.textField.text, let calories = Int(caloriesText) else {
      let alert = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alert, animated: true, completion: nil)
      return
    }
    
    let foodId = foodItem?.id
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.center = self.view.center
    activityIndicator.startAnimating()
    self.view.addSubview(activityIndicator)
    
    if isEditing, let foodId = foodId {
      viewModel.updateFood(
        id: foodId,
        name: name,
        description: description,
        categoryId: categoryId,
        calories: calories,
        tags: selectedTagIDs,
        images: selectedImages
      ) { [weak self] result in
        DispatchQueue.main.async {
          activityIndicator.stopAnimating()
          activityIndicator.removeFromSuperview()
          guard let self = self else { return }
          
          switch result {
            case .success(let response):
              print("Food updated successfully: \(response)")
              
              let alert = UIAlertController(title: "Success", message: "Food updated successfully!", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true) // Pop to root
              })
              self.present(alert, animated: true)
            case .failure(let error):
              let alert = UIAlertController(title: "Error", message: "Failed to update food: \(error.localizedDescription)", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default))
              self.present(alert, animated: true)
          }
        }
      }
    } else {
      viewModel.createFood(
        name: name,
        description: description,
        categoryId: categoryId,
        calories: calories,
        tags: selectedTagIDs,
        images: selectedImages
      ) { [weak self] result in
        DispatchQueue.main.async {
          activityIndicator.stopAnimating()
          activityIndicator.removeFromSuperview()
          guard let self = self else { return }
          
          switch result {
            case .success(let response):
              print("Food created successfully: \(response)")
              let alert = UIAlertController(title: "Success", message: "Food added successfully!", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.nameField.textField.text = ""
                self.descriptionView.textView.text = ""
                self.categoryView.category = nil
                self.caloriesView.textField.text = ""
                self.tags = []
                self.selectedTagIDs = []
                self.selectedTagNames = []
                self.tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                self.selectedImages = []
                self.imagesCollectionView.reloadData()
              })
              self.present(alert, animated: true)
              
            case .failure(let error):
              let alert = UIAlertController(title: "Error", message: "Failed to add food: \(error.localizedDescription)", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default))
              self.present(alert, animated: true)
          }
        }
      }
    }
  }
  
  // MARK: - Tag Management
  private func addTag(_ tag: String) {
    guard !tag.isEmpty, !tags.contains(tag) else { return }
    
    tags.append(tag)
    selectedTagNames.append(tag)
    
    
    if let tagID = tagsDictionary[tag] {
      selectedTagIDs.append(tagID)
    } else {
      let alert = UIAlertController(title: "Invalid Tag", message: "Please enter a valid tag.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      present(alert, animated: true)
    }
    
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
      
      if let idIndex = selectedTagNames.firstIndex(of: tag), let tagID = tagsDictionary[tag] {
        selectedTagNames.remove(at: idIndex)
        if let idToRemoveIndex = selectedTagIDs.firstIndex(of: tagID){
          selectedTagIDs.remove(at: idToRemoveIndex)
        }
      }
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

extension AddViewController: CategoryPickerViewDelegate {
  func categoryPickerView(_ pickerView: CategoryPickerView, didSelect category: Category?) {
    print("Selected category: \(category?.name ?? "None") (ID: \(category?.id ?? -1))")
  }
}
