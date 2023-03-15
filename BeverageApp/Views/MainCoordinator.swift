//
//  MainCoordinator.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 14/03/2023.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = SearchDrinkViewController.instantiate()
        viewController.coordinator = self
        viewController.viewModel = SearchDrinkViewModel(ingredientsStorage: IngredientsListStorage())
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showDrinksCollectionView(with ingredient: Ingredient) {
        let viewController = DrinksCollectionViewController.instantiate()
        viewController.coordinator = self
        viewController.viewModel = DrinksCollectionViewModel(ingredient: ingredient)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showDetailsView(for drink: Drink, withImage image: UIImage) {
        let viewController = DrinkDetailsViewController.instantiate()
        viewController.coordinator = self
        viewController.viewModel = DrinkDetailsViewModel(drink: drink, drinkImage: image)
        navigationController.pushViewController(viewController, animated: false)
    }
}
