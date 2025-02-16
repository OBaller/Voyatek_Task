//
//  FoodViewModel.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 16/02/2025.
//

import Foundation

class FoodViewModel {
  var foods: [FoodItem] = []
  var categories: [Category] = []
  var onDataUpdated: (() -> Void)?
  var onCategoriesUpdated: (() -> Void)?
  var onError: ((String) -> Void)?
  
  func fetchFood() {
    NetworkManager.shared.fetchFood { [weak self] result in
      DispatchQueue.main.async {
        switch result {
          case .success(let response):
            self?.foods = response.data
            self?.onDataUpdated?()
          case .failure(let error):
            self?.onError?("\(error.localizedDescription) whatever happened here")
        }
      }
    }
  }
  
  func fetchCategories() {
    NetworkManager.shared.fetchCategories { [weak self] result in
      DispatchQueue.main.async {
        switch result {
          case .success(let response):
            self?.categories = response.data
            self?.onCategoriesUpdated?()
          case .failure(let error):
            self?.onError?("Failed to fetch categories: \(error.localizedDescription)")
        }
      }
    }
  }
}
