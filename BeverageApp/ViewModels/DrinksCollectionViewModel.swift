//
//  DrinksCollectionViewModel.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 15/03/2023.
//

import Foundation
import UIKit

class DrinksCollectionViewModel {
    var onDownloadCompleted: ((Bool, Error?) -> Void)?
    
    private let ingredient: Ingredient

    private var networkService: NetworkService?
    private(set) var drinks: [Drink] = []
    private(set) var drinksImages: [UIImage] = []

    init(ingredient: Ingredient) {
        self.ingredient = ingredient
    }
    
    func downloadDrinks() {
        downloadDrinks { [weak self] drinksBar, error in
            guard let drinksBar = drinksBar else {
                self?.onDownloadCompleted?(false, error)
                return
            }
            self?.drinks = drinksBar.drinks
            self?.onDownloadCompleted?(true, error)
        }
    }
    
    private func downloadDrinks(_ completion: @escaping (DrinksBar?, Error?) -> Void) {
        networkService = NetworkManager()
        networkService?.searchDrinksBy(ingredient: ingredient) { result in
            switch result {
            case .success(let drinksBar):
                let dispatchGroup = DispatchGroup()
                drinksBar.drinks.forEach { drink in
                    dispatchGroup.enter()
                    if let imageName = drink.image.components(separatedBy: "/").last {
                        self.networkService?.getDrinkImage(named: imageName) { result in
                            switch result {
                            case .success(let drinkImage):
                                self.drinksImages.append(drinkImage)
                            case .failure(let error):
                                completion(nil, error)
                            }
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    completion(drinksBar, nil)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
