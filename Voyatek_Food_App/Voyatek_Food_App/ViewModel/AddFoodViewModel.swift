//
//  AddFoodViewModel.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 17/02/2025.
//

import UIKit

class AddFoodViewModel {
  private let networkManager: NetworkManager
  var validTags: [Tag] = []
  var onTagsUpdated: (() -> Void)?
  var onError: ((String) -> Void)?
  var validTagsDictionary: [String: Int] = [:]
  
  init(networkManager: NetworkManager = NetworkManager.shared) {
    self.networkManager = networkManager
  }
  
  func updateFood(
    id: Int,
    name: String,
    description: String,
    categoryId: Int,
    calories: Int,
    tags: [Int],
    images: [UIImage],
    completion: @escaping (Result<FoodUpdateResponse, Error>) -> Void
  ) {
    networkManager.updateFood(
      id: id,
      name: name,
      description: description,
      categoryId: categoryId,
      calories: calories,
      tags: tags,
      images: images,
      completion: completion
    )
  }
  
  func createFood(
    name: String,
    description: String,
    categoryId: Int,
    calories: Int,
    tags: [Int],
    images: [UIImage],
    completion: @escaping (Result<FoodUpdateResponse, Error>) -> Void
  ) {
    guard !name.isEmpty, !description.isEmpty else {
      completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Name and description cannot be empty"])))
      return
    }
    
    networkManager.createFood(
      name: name,
      description: description,
      categoryId: categoryId,
      calories: calories,
      tags: tags,
      images: images,
      completion: completion
    )
  }
  
  func fetchTags() {
    NetworkManager.shared.getTags { [weak self] result in
      DispatchQueue.main.async {
        switch result {
          case .success(let response):
            let tagsDict = Dictionary(uniqueKeysWithValues: response.data.map { ($0.name, $0.id) })
            self?.validTagsDictionary = tagsDict
            self?.onTagsUpdated?()
            
          case .failure(let error):
            self?.onError?("Failed to fetch tags: \(error.localizedDescription)")
        }
      }
    }
  }
  
}
