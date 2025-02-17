//
//  NetworkService.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 16/02/2025.
//

import Foundation

class NetworkManager {
  static let shared = NetworkManager()
  
  private init() {}
  
  // MARK: - services/task
  func fetchFood(completion: @escaping (Result<FoodResponse, Error>) -> Void) {
    let urlString = "https://assessment.vgtechdemo.com/api/foods"
    
    fetchGenericJSON(head: .header, token: nil, header: "Authorization", urlString: urlString, method: "GET", body: nil, queryItems: nil) { (result: Result<FoodResponse, Error>) in
      switch result {
        case .success(let response):
          print(response)
          completion(.success(response))
        case .failure(let error):
          completion(.failure(error))
      }
    }
  }
  
  
  func fetchCategories(completion: @escaping (Result<CategoriesResponse, Error>) -> Void) {
    let urlString = "https://assessment.vgtechdemo.com/api/categories"
    
    fetchGenericJSON(head: .header, token: nil, header: "Authorization", urlString: urlString, method: "GET", body: nil, queryItems: nil) { (result: Result<CategoriesResponse, Error>) in
      switch result {
        case .success(let response):
          print(response)
          completion(.success(response))
        case .failure(let error):
          completion(.failure(error))
      }
    }
  }
  
  func getTags(completion: @escaping (Result<TagsResponse, Error>) -> Void) {
    let urlString = "https://assessment.vgtechdemo.com/api/tags"
    
    fetchGenericJSON(head: .header, token: nil, header: "Authorization", urlString: urlString, method: "GET", body: nil, queryItems: nil) { (result: Result<TagsResponse, Error>) in
      switch result {
        case .success(let response):
//          print(response)
          completion(.success(response))
        case .failure(let error):
          completion(.failure(error))
      }
    }
  }
  
  
  // MARK: - Generic function to make network requests
  func fetchGenericJSON<T: Decodable>(
    head: Token,
    token: String?,
    header: String?,
    urlString: String,
    method: String = "GET",
    body: [String: Any]? = nil,
    queryItems: [URLQueryItem]? = nil,
    completion: @escaping (Result<T, Error>) -> Void
  ) {
    var components = URLComponents(string: urlString)
    components?.queryItems = queryItems
    
    guard let url = components?.url else {
      completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method
    
    if let body = body {
      do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
      } catch {
        completion(.failure(error))
        return
      }
    }
    
    if head == .header, let token = token, let header = header {
      request.setValue("Bearer \(token)", forHTTPHeaderField: header)
    }
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let data = data else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
        return
      }
      if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
        print("JSON Response: \(json)")
      } else {
        print("Failed to serialize JSON")
      }
      do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let objects = try decoder.decode(T.self, from: data)
        completion(.success(objects))
      } catch {
        completion(.failure(error))
      }
    }.resume()
  }
}

enum Token {
  case header
  case noHeader
}
