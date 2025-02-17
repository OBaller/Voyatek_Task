//
//  FoodDetailViewController.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 14/02/2025.
//

import UIKit

import UIKit

class FoodDetailViewController: UIViewController {
  private let food: FoodItem
  
  // MARK: - UI Components
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  private let contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let imagePageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.currentPageIndicatorTintColor = .white
    pageControl.pageIndicatorTintColor = .systemGray3
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    return pageControl
  }()
  
  private let imagesCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20, weight: .semibold)
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let tagsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.numberOfLines = 0
    label.textColor = .lightGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let nutritionLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.text = "Nutrition"
    label.textColor = .lightGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let caloriesView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 251/255, alpha: 1)
    view.layer.cornerRadius = 8
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
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
  
  private let caloriesLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.textColor = .lightGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let caloriesStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 4
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let nutritionStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 4
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let notesLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.text = "Notes"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  
  private let addNotesButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "Note"), for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
    button.setTitle("Add notes", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let removeButton: PrimaryButton = {
    let button = PrimaryButton()
    button.setTitle("Remove from collection", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
    button.setTitleColor(.white, for: .normal)
    button.isEnabled = true
    return button
  }()
  
  // MARK: - Initialization
  init(food: FoodItem) {
    self.food = food
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupNavigationBar()
    configureWithFood()
  }
  
  // MARK: - Setup
  private func setupUI() {
    view.backgroundColor = .systemBackground
    
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    
    contentView.addSubview(imagesCollectionView)
    contentView.addSubview(imagePageControl)
    contentView.addSubview(titleLabel)
    contentView.addSubview(tagsStackView)
    contentView.addSubview(descriptionLabel)
    contentView.addSubview(caloriesView)
    contentView.addSubview(notesLabel)
    contentView.addSubview(addNotesButton)
    contentView.addSubview(removeButton)
    
    caloriesView.addSubview(nutritionStackView)
    nutritionStackView.addArrangedSubview(nutritionLabel)
    
    caloriesStackView.addArrangedSubview(caloriesImageView)
    caloriesStackView.addArrangedSubview(caloriesLabel)
    
    nutritionStackView.addArrangedSubview(caloriesStackView)
    
    setupConstraints()
    setupCollectionView()
  }
  
  private func setupConstraints() {
    imagesCollectionView.newAnchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor)
    imagesCollectionView.setHeight(height: 300)
    
    imagePageControl.centerX(inView: imagesCollectionView)
    imagePageControl.newAnchor(bottom: imagesCollectionView.bottomAnchor, paddingBottom: 16)
    
    titleLabel.newAnchor(top: imagesCollectionView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
    
    tagsStackView.newAnchor(top: titleLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 8, paddingLeft: 16)
    
    descriptionLabel.newAnchor(top: tagsStackView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
    
    caloriesView.newAnchor(top: descriptionLabel.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 24, paddingLeft: 16, paddingRight: 16)
    caloriesView.setHeight(height: 60)
    nutritionStackView.newAnchor(top: caloriesView.topAnchor, left: caloriesView.leftAnchor, bottom: caloriesView.bottomAnchor, right: caloriesView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
    
    notesLabel.newAnchor(top: caloriesView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 24, paddingLeft: 16, paddingRight: 16)
    
    addNotesButton.newAnchor(top: notesLabel.bottomAnchor, left: contentView.leftAnchor, paddingTop: 4, paddingLeft: 16)
    
    
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      
      removeButton.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 60),
      removeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      removeButton.heightAnchor.constraint(equalToConstant: 50),
      removeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
    ])
  }
  
  private func setupNavigationBar() {
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(editTapped)),
      UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoriteTapped))
    ]
  }
  
  private func setupCollectionView() {
    imagesCollectionView.register(FoodImageCell.self, forCellWithReuseIdentifier: "FoodImageCell")
    imagesCollectionView.delegate = self
    imagesCollectionView.dataSource = self
    imagePageControl.numberOfPages = food.foodImages.count
  }
  
  private func configureWithFood() {
    titleLabel.text = food.name
    descriptionLabel.text = food.description
    caloriesLabel.text = "\(food.calories) Calories"
    
    // Setup tags
    food.foodTags.forEach { tag in
      let tagView = TagView(title: tag)
      tagsStackView.addArrangedSubview(tagView)
    }
  }
  
  // MARK: - Actions
  @objc private func editTapped() {
    let addVC = AddViewController()
    addVC.isForEditing = true
    addVC.foodItem = self.food
    navigationController?.pushViewController(addVC, animated: true)
  }
  
  @objc private func favoriteTapped() {
    
  }
}

// MARK: - UICollectionView
extension FoodDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return food.foodImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodImageCell", for: indexPath) as! FoodImageCell
    cell.configure(with: food.foodImages[indexPath.row].imageURL)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collectionView.bounds.size
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    imagePageControl.currentPage = page
  }
}
