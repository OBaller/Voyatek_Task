//
//  APIError.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 16/02/2025.
//

import Foundation
struct ErrorResponse: Codable {
  let status: String
  let code: Int
  let message: String
}
