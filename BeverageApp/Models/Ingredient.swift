//
//  Ingredient.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 13/03/2023.
//

import Foundation

struct DrinkIngredients: Codable {
    var ingredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey {
        case ingredients = "drinks"
    }
}

struct Ingredient: Codable {
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strIngredient1"
    }
}
