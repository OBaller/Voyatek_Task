//
//  NetworkService+Extension.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 17/02/2025.
//

import Foundation
import UIKit

extension NetworkManager {
  
  func createFood(
    name: String,
    description: String,
    categoryId: Int,
    calories: Int,
    tags: [Int],
    images: [UIImage],
    completion: @escaping (Result<FoodUpdateResponse, Error>) -> Void
  ) {
    let urlString = "https://assessment.vgtechdemo.com/api/foods"
    sendFoodRequest(urlString: urlString, id: nil, name: name, description: description, categoryId: categoryId, calories: calories, tags: tags, images: images, completion: completion)
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
    let urlString = "https://assessment.vgtechdemo.com/api/foods/\(id)"
    sendFoodRequest(urlString: urlString, id: id, name: name, description: description, categoryId: categoryId, calories: calories, tags: tags, images: images, completion: completion)
  }
  
  // MARK: - Private Helper Function
  private func sendFoodRequest(
    urlString: String,
    id: Int?,
    name: String,
    description: String,
    categoryId: Int,
    calories: Int,
    tags: [Int],
    images: [UIImage],
    completion: @escaping (Result<FoodUpdateResponse, Error>) -> Void
  ) {
    guard let url = URL(string: urlString) else {
      completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let boundary = "Boundary-\(UUID().uuidString)"
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    let httpBody = NSMutableData()
    
    // Add text parameters
    addFormField(httpBody, name: "name", value: name, boundary: boundary)
    addFormField(httpBody, name: "description", value: description, boundary: boundary)
    addFormField(httpBody, name: "category_id", value: String(categoryId), boundary: boundary)
    addFormField(httpBody, name: "calories", value: String(calories), boundary: boundary)
    
    // Add tags
    for (index, tag) in tags.enumerated() {
      addFormField(httpBody, name: "tags[\(index)]", value: String(tag), boundary: boundary)
    }
    
    // Add images
    for (index, image) in images.enumerated() {
      guard var imageData = image.jpegData(compressionQuality: 0.7) else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
        return
      }
      
      // Check if the image size exceeds 2MB (2048 kilobytes)
      let maxSizeInBytes = 2048 * 1024 // 2MB in bytes
      var compressionQuality: CGFloat = 0.7
      
      // Reduce quality until the image size is below 2MB
      while imageData.count > maxSizeInBytes && compressionQuality > 0.1 {
        compressionQuality -= 0.1
        if let compressedData = image.jpegData(compressionQuality: compressionQuality) {
          imageData = compressedData
        }
      }
      
      // If the image is still too large, skip it or show an error
      if imageData.count > maxSizeInBytes {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Image \(index) is too large after compression"])))
        return
      }
      
      addFileData(httpBody, name: "images[\(index)]", data: imageData, filename: "image\(index).jpg", boundary: boundary)
    }
    
    // Close the form data
    httpBody.appendString("--\(boundary)--\r\n")
    
    request.httpBody = httpBody as Data
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let data = data else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let updateResponse = try decoder.decode(FoodUpdateResponse.self, from: data)
        completion(.success(updateResponse))
      } catch {
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
          print("JSON Response: \(json)")
        } else {
          print("Failed to serialize JSON")
        }
        completion(.failure(error))
      }
    }.resume()
  }
  
  // MARK: - Helper Functions
  private func addFormField(_ httpBody: NSMutableData, name: String, value: String, boundary: String) {
    httpBody.appendString("--\(boundary)\r\n")
    httpBody.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
    httpBody.appendString("\(value)\r\n")
  }
  
  private func addFileData(_ httpBody: NSMutableData, name: String, data: Data, filename: String, boundary: String) {
    httpBody.appendString("--\(boundary)\r\n")
    httpBody.appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
    httpBody.appendString("Content-Type: image/jpeg\r\n\r\n")
    httpBody.append(data)
    httpBody.appendString("\r\n")
  }
}

// MARK: - NSMutableData Extension
extension NSMutableData {
  func appendString(_ string: String) {
    let data = string.data(using: String.Encoding.utf8)
    append(data!)
  }
}
