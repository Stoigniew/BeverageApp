//
//  Drink.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 13/03/2023.
//

import Foundation

struct DrinksBar: Decodable {
    var drinks: [Drink]
}

struct Drink: Decodable, Identifiable {
    var id: String
    var name: String
    var image: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case image = "strDrinkThumb"
    }
}

struct DrinkDetailsList: Decodable {
    var drinks: [DrinkDetails]
}

struct DrinkDetails: Decodable {
    var id: String
    var name: String
    var category: String
    var alcoholic: String
    var instructions: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case alcoholic = "strAlcoholic"
        case instructions = "strInstructions"
    }
}
