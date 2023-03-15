//
//  NetworkManager.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 13/03/2023.
//

import Foundation
import UIKit

enum NetworkManagerError: Error {
    case imageNotDownloaded
}

struct NetworkManager: NetworkService {
    private let scheme = "https"
    private let host = "www.thecocktaildb.com"
    
    func getListOfIngridients(_ completion: @escaping (Result<DrinkIngredients, Error>) -> Void) {
        var components = provideURLComponents(for: API.getIngridientsList)
        components.queryItems = [
            URLQueryItem(name: "i", value: "list")
        ]
        
        guard let url = components.url else {
            preconditionFailure("URL construction failed")
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let ingredients = try JSONDecoder().decode(DrinkIngredients.self, from: data)
                        completion(.success(ingredients))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
    func getDrinkImage(named imageName: String, _ completion: @escaping (Result<UIImage, NetworkManagerError>) -> Void) {
        let components = provideURLComponents(for: API.getDrinkImage(imageName))

        guard let url = components.url else {
            preconditionFailure("URL construction failed")
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    guard let image = UIImage(data: data) else {
                        completion(.failure(.imageNotDownloaded))
                        return
                    }
                    completion(.success(image))
                }
            }
        }.resume()
    }
    
    func getDrinkDetails(for drink: Drink, _ completion: @escaping (Result<DrinkDetailsList, Error>) -> Void) {
        var components = provideURLComponents(for: API.getDrinkDetails)
        components.queryItems = [
            URLQueryItem(name: "i", value: drink.id)
        ]
        
        guard let url = components.url else {
            preconditionFailure("URL construction failed")
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let drinkDetails = try JSONDecoder().decode(DrinkDetailsList.self, from: data)
                        completion(.success(drinkDetails))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
    func searchDrinksBy(ingredient: Ingredient, _ completion: @escaping (Result<DrinksBar, Error>) -> Void) {
        var components = provideURLComponents(for: API.searchDrinksByIngredient)
        components.queryItems = [
            URLQueryItem(name: "i", value: ingredient.name)
        ]
        
        guard let url = components.url else {
            preconditionFailure("URL construction failed")
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let drinks = try JSONDecoder().decode(DrinksBar.self, from: data)
                        completion(.success(drinks))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
    private func provideURLComponents(for api: API) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = api.path
        
        return components
    }
}
