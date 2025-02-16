//
//  CategoriesResponse.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 16/02/2025.
//

import Foundation

struct Category: Codable {
    let id: Int
    let name: String
    let description: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct CategoriesResponse: Codable {
    let status: String
    let message: String
    let data: [Category]
}
