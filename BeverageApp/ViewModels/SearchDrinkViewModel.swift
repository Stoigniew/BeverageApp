//
//  SearchDrinkViewModel.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 13/03/2023.
//

import Foundation

class SearchDrinkViewModel {
    var onDownloadCompleted: ((Bool, Error?) -> Void)?

    private var networkService: NetworkService?
    private var ingredientsStorage: IngredientsListStorage
    private var needsIngredientsDownload: Bool {
        ingredientsStorage.retrieveIngredients()?.ingredients.isEmpty ?? true
    }
    
    private(set) var drinkIngredients: DrinkIngredients? {
        get {
            ingredientsStorage.retrieveIngredients()
        }
        set {}
    }
    
    init(ingredientsStorage: IngredientsListStorage) {
        self.ingredientsStorage = ingredientsStorage
    }
    
    func setupIngredients() {
        if needsIngredientsDownload {
            downloadIngredients()
        }
        onDownloadCompleted?(true, nil)
    }
    
    private func downloadIngredients() {
        downloadIngredients { [weak self] ingredients, error in
            guard let ingredients = ingredients else {
                self?.onDownloadCompleted?(false, error)
                return
            }
            self?.ingredientsStorage.store(ingredients: ingredients)
            self?.onDownloadCompleted?(true, error)
        }
    }
    
    private func downloadIngredients(_ completion: @escaping (DrinkIngredients?, Error?) -> Void) {
        networkService = NetworkManager()
        networkService?.getListOfIngridients { result in
            switch result {
            case .success(let ingredients):
                completion(ingredients, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
