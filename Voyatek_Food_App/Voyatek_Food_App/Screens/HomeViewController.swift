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
    return searchBar
  }()
  
  private let categoryScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.translatesAutoresizingMaskIntoConstraints = false
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
  
  
  public var foods: [Food] = DummyData.foods
  
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
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationController?.navigationBar.tintColor = .label // Ensures visibility in dark/light mode
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
    let categories = ["All", "Morning Feast", "Sunrise Meal", "Dawn Delicacies"]
    
    for (index, category) in categories.enumerated() {
      let button = CategoryButton(title: category)
      button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
      categoryStackView.addArrangedSubview(button)
      
      if index == 0 {
        button.isSelected = true
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
      categoryScrollView.heightAnchor.constraint(equalToConstant: 44),
      
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
  
  // MARK: - Actions
  @objc private func profileTapped() {
    // Handle profile tap
  }
  
  @objc private func categoryTapped(_ sender: CategoryButton) {
    for view in categoryStackView.arrangedSubviews {
      if let button = view as? CategoryButton {
        button.isSelected = (button == sender)
      }
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
    // Handle search
  }
}
