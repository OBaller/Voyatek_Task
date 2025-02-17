//
//  TagsResponse.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 17/02/2025.
//

import Foundation

struct TagsResponse: Decodable {
    let status: String
    let message: String
    let data: [Tag]
}

struct Tag: Decodable {
    let id: Int
    let name: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
