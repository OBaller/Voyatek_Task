//
//  ViewController.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 14/02/2025.
//

// HomeViewController.swift
import UIKit

class HomeViewController: UIViewController {
  // MARK: - Properties
  private let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "Search foods..."
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
    searchBar.backgroundColor = UIColor.clear
    
    if let textField = searchBar.value(forKey: "searchField") as? UITextField {
      textField.backgroundColor = UIColor(red: 247/255, green: 249/255, blue: 252/255, alpha: 1)
      textField.layer.cornerRadius = 4
      textField.clipsToBounds = true
      textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
      
      textField.attributedPlaceholder = NSAttributedString(
        string: "Search foods...",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
      )
      if let leftView = textField.leftView as? UIImageView {
        leftView.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        leftView.tintColor = UIColor.lightGray
      }
    }
    return searchBar
  }()
  
  
  private let categoryScrollView: CategoryScrollView = {
    let scrollView = CategoryScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.delaysContentTouches = false
    scrollView.canCancelContentTouches = true
    return scrollView
  }()
  
  private let categoryStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 16
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.register(FoodTableViewCell.self, forCellReuseIdentifier: "FoodCell")
    return tableView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 18, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .systemGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  
  private let foodViewModel = FoodViewModel()
  private var foods: [FoodItem] = []
  private var categories: [Category] = []
  private var allFoods: [FoodItem] = []
  private var filteredFoods: [FoodItem] = []
  private var searchText: String = ""
  
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let iconImage = UIImage(named: "NotificationIcon")?.withRenderingMode(.alwaysOriginal)
    let notification = UIBarButtonItem(image: iconImage, style: .plain, target: self, action: #selector(profileTapped))
    navigationItem.rightBarButtonItem = notification
    
    let userImage = UIImage(named: "UserAvatar")?.withRenderingMode(.alwaysOriginal)
    let user = UIBarButtonItem(image: userImage, style: .plain, target: self, action: #selector(profileTapped))
    navigationItem.leftBarButtonItem = user
    
    setupUI()
    setupConstraints()
    setupViewModel()
    foodViewModel.fetchFood()
    foodViewModel.fetchCategories()
    categoryScrollView.delegate = self
    categoryStackView.isUserInteractionEnabled = true
    categoryScrollView.isUserInteractionEnabled = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationController?.navigationBar.tintColor = .label
    foodViewModel.fetchFood()
  }
  
  
  // MARK: - Setup
  private func setupUI() {
    view.backgroundColor = .systemBackground
    
    view.addSubview(searchBar)
    view.addSubview(categoryScrollView)
    categoryScrollView.addSubview(categoryStackView)
    view.addSubview(tableView)
    
    setupCategories()
    
    tableView.delegate = self
    tableView.dataSource = self
    searchBar.delegate = self
  }
  
  private func setupCategories() {
    let allButton = CategoryButton(title: "All")
    allButton.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
    categoryStackView.addArrangedSubview(allButton)
    allButton.isSelected = true
    
    foodViewModel.onCategoriesUpdated = { [weak self] in
      DispatchQueue.main.async {
        guard let self = self else { return }
        
        self.categoryStackView.arrangedSubviews.forEach { view in
          if let categoryButton = view as? CategoryButton, categoryButton.title(for: .normal) != "All" {
            self.categoryStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
          }
        }
        
        for category in self.foodViewModel.categories {
          let button = CategoryButton(title: category.name)
          button.addTarget(self, action: #selector(self.categoryTapped(_:)), for: .touchUpInside)
          self.categoryStackView.addArrangedSubview(button)
        }
        
        self.categoryScrollView.layoutIfNeeded()
      }
    }
  }
  
  
  private func setupConstraints() {
    let textStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    textStackView.axis = .vertical
    textStackView.spacing = 2
    textStackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(textStackView)
    
    titleLabel.text = "Hey there, Lucy!"
    subtitleLabel.text = "Are you excited to create a tasty dish today?"
    
    NSLayoutConstraint.activate([
      textStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      textStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      
      searchBar.topAnchor.constraint(equalTo: textStackView.bottomAnchor, constant: 10),
      searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      categoryScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
      categoryScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      categoryScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      categoryScrollView.heightAnchor.constraint(equalToConstant: 40),
      
      categoryStackView.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
      categoryStackView.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor, constant: 16),
      categoryStackView.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor, constant: -16),
      categoryStackView.heightAnchor.constraint(equalTo: categoryScrollView.heightAnchor),
      
      tableView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: 8),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func setupViewModel() {
    foodViewModel.onDataUpdated = { [weak self] in
      self?.foods = self?.foodViewModel.foods ?? []
      self?.allFoods = self?.foodViewModel.foods ?? []
      self?.tableView.reloadData()
    }
    
    foodViewModel.onError = { [weak self] errorMessage in
      DispatchQueue.main.async {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self?.present(alert, animated: true)
      }
    }
    
    
  }
  
  // MARK: - Actions
  @objc private func profileTapped() {
    // Handle profile tap
  }
  
  @objc private func categoryTapped(_ sender: Any) {
    var selectedButton: CategoryButton?
    
    if let button = sender as? CategoryButton {
      selectedButton = button
    } else if let gesture = sender as? UITapGestureRecognizer, let button = gesture.view as? CategoryButton {
      selectedButton = button
    }
    
    guard let button = selectedButton else {
      print("Invalid sender for categoryTapped")
      return
    }
    
    for view in categoryStackView.arrangedSubviews {
      if let categoryButton = view as? CategoryButton {
        categoryButton.isSelected = (categoryButton == button)
      }
    }
    
    
    if let selectedCategory = button.title(for: .normal) {
      switch selectedCategory {
        case "All":
          foods = allFoods
          tableView.reloadData()
          print("All category selected")
        default:
          print("\(selectedCategory) category selected")
          filterFoodsByCategory(selectedCategory)
      }
    }
  }
  
  
  private func filterFoodsByCategory(_ categoryName: String) {
    let filteredFoods = foodViewModel.foods.filter { foodItem in
      foodItem.category.name == categoryName
    }
    foods = filteredFoods
    tableView.reloadData()
    
    if filteredFoods.isEmpty {
      print("No food found for this category")
      let alert = UIAlertController(title: "No Food Available", message: "No food items found for the selected category.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      self.present(alert, animated: true)
    }
  }
}

// MARK: - UITableViewDelegate & DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return foods.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as? FoodTableViewCell else {
      return UITableViewCell()
    }
    cell.configure(with: foods[indexPath.row])
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 280
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let food = foods[indexPath.row]
    let detailVC = FoodDetailViewController(food: food)
    detailVC.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(detailVC, animated: true)
  }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.searchText = searchText
    
    if searchText.count >= 3 || searchText.isEmpty {
      performSearch()
    }
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    performSearch()
  }
  
  private func performSearch() {
    if searchText.isEmpty {
      foods = allFoods
    } else {
      let lowercasedSearchText = searchText.lowercased()
      
      filteredFoods = allFoods.filter { foodItem in
        let nameMatch = foodItem.name.lowercased().contains(lowercasedSearchText)
        let categoryMatch = foodItem.category.name.lowercased().contains(lowercasedSearchText)
        let tagsMatch = foodItem.foodTags.contains { tag in
          tag.lowercased().contains(lowercasedSearchText)
        }
        return nameMatch || categoryMatch || tagsMatch
      }
      foods = filteredFoods
    }
    tableView.reloadData()
  }
  
}

extension HomeViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    categoryStackView.arrangedSubviews.forEach { view in
      if let button = view as? UIButton {
        button.isHighlighted = false
      }
    }
  }
}
