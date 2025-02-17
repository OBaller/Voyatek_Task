//
//  FoodUpdateResponse.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 17/02/2025.
//

import Foundation

struct FoodUpdateResponse: Codable {
    let status: String
    let message: String
    let data: FoodItem
}
