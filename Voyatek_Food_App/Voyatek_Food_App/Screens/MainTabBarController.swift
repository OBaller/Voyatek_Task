//
//  MainTabBarController.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 14/02/2025.
//

import UIKit

class MainTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewControllers()
    setupAppearance()
  }
  
  private func setupViewControllers() {
    let homeVC = HomeViewController()
    let homeNav = UINavigationController(rootViewController: homeVC)
    homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
    
    let generatorVC = GeneratorViewController()
    generatorVC.tabBarItem = UITabBarItem(title: "Generator", image: UIImage(systemName: "wand.and.stars"), tag: 1)
    
    let addVC = AddViewController()
    addVC.tabBarItem = UITabBarItem(title: "Add", image: UIImage(systemName: "plus.circle"), tag: 2)
    
    let favoriteVC = FavouriteViewController()
    favoriteVC.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage(systemName: "heart"), tag: 3)
    
    let plannerVC = PlannerViewController()
    plannerVC.tabBarItem = UITabBarItem(title: "Planner", image: UIImage(systemName: "calendar"), tag: 4)
    
    viewControllers = [homeNav, generatorVC, addVC, favoriteVC, plannerVC]
  }
  
  private func setupAppearance() {
    tabBar.tintColor = .systemBlue
    tabBar.backgroundColor = .systemBackground
  }
  
}
