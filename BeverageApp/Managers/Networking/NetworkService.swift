//
//  NetworkService.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 13/03/2023.
//

import Foundation
import UIKit

protocol NetworkService {
    func getListOfIngridients(_ completion: @escaping (Result<DrinkIngredients, Error>) -> Void)
    func getDrinkImage(named imageName: String, _ completion: @escaping (Result<UIImage, NetworkManagerError>) -> Void)
    func searchDrinksBy(ingredient: Ingredient, _ completion: @escaping (Result<DrinksBar, Error>) -> Void)
    func getDrinkDetails(for drink: Drink, _ completion: @escaping (Result<DrinkDetailsList, Error>) -> Void)
}

enum API {
    case getIngridientsList
    case getDrinkImage(String)
    case getDrinkDetails
    case searchDrinksByIngredient
    
    var path: String {
        switch self {
        case .getIngridientsList:
            return "/api/json/v1/1/list.php"
        case .getDrinkImage(let imageName):
            return "/images/media/drink/\(imageName)/preview"
        case .searchDrinksByIngredient:
            return "/api/json/v1/1/filter.php"
        case .getDrinkDetails:
            return "/api/json/v1/1/lookup.php"
        }
    }
}
