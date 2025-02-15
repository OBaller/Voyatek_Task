//
//  FoodModel.swift
//  Voyatek_Food_App
//
//  Created by Naseem Oyebola on 14/02/2025.
//

import Foundation

struct Food: Codable {
    let id: String
    let name: String
    let description: String
    let calories: Int
    let category: FoodCategory
    let tags: [String]
    let imageURLs: [String]
    
    init(id: String = UUID().uuidString,
         name: String,
         description: String,
         calories: Int,
         category: FoodCategory,
         tags: [String],
         imageURLs: [String]) {
        self.id = id
        self.name = name
        self.description = description
        self.calories = calories
        self.category = category
        self.tags = tags
        self.imageURLs = imageURLs
    }
}

enum FoodCategory: String, Codable {
    case morningFeast = "Morning Feast"
    case sunriseMeal = "Sunrise Meal"
    case dawnDelicacies = "Dawn Delicacies"
}

// DummyData.swift
struct DummyData {
    static let foods: [Food] = [
        Food(name: "Garlic Butter Shrimp Pasta",
             description: "Creamy garlic butter sauce coating perfectly cooked shrimp and pasta, garnished with fresh parsley and cherry tomatoes.",
             calories: 320,
             category: .dawnDelicacies,
             tags: ["healthy", "vegetarian"],
             imageURLs: ["shrimp_pasta_1", "shrimp_pasta_2", "shrimp_pasta_3"]),
        
        Food(name: "Lemon Herb Chicken Fettuccine",
             description: "Fresh fettuccine pasta with grilled chicken in a light lemon herb sauce, topped with parmesan cheese.",
             calories: 250,
             category: .dawnDelicacies,
             tags: ["healthy", "natural fat", "edible"],
             imageURLs: ["chicken_fettuccine_1", "chicken_fettuccine_2", "chicken_fettuccine_3"]),
        
        Food(name: "Açaí Breakfast Bowl",
             description: "Nutrient-rich açaí blend topped with fresh berries, banana slices, granola, and a drizzle of honey.",
             calories: 380,
             category: .morningFeast,
             tags: ["healthy", "low fat", "gluten free"],
             imageURLs: ["breakfast_bowl_1", "breakfast_bowl_2"]),
        
        Food(name: "Avocado Toast Supreme",
             description: "Whole grain toast topped with mashed avocado, poached eggs, cherry tomatoes, and microgreens.",
             calories: 290,
             category: .sunriseMeal,
             tags: ["healthy", "bromate free", "whole grain"],
             imageURLs: ["avocado_toast_1", "avocado_toast_2", "avocado_toast_3"]),
        
        Food(name: "Grilled Salmon Salad",
             description: "Fresh grilled salmon served over mixed greens with quinoa, cherry tomatoes, and lemon vinaigrette.",
             calories: 410,
             category: .dawnDelicacies,
             tags: ["healthy", "whole grain", "low fat"],
             imageURLs: ["salmon_salad_1", "salmon_salad_2", "salmon_salad_3"])
    ]
}
