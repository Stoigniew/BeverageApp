//
//  IngredientsListStorage.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 14/03/2023.
//

import Foundation

class IngredientsListStorage {
    
    private let key = "ingredients_list_storage_key"
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func retrieveIngredients() -> DrinkIngredients? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        let ingredients = try? JSONDecoder().decode(DrinkIngredients.self, from: data)
        return ingredients
    }
    
    func store(ingredients: DrinkIngredients) {
        let encodedIngredients = try? JSONEncoder().encode(ingredients)
        userDefaults.set(encodedIngredients, forKey: key)
    }
}
