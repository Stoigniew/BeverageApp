//
//  DrinkDetailsViewModel.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 13/03/2023.
//

import Foundation
import UIKit

class DrinkDetailsViewModel {
    var onDownloadCompleted: ((Bool, Error?) -> Void)?
    private var networkService: NetworkService?

    private let drink: Drink
    private(set) var image: UIImage
    private(set) var details: DrinkDetails?

    init(drink: Drink, drinkImage: UIImage) {
        self.drink = drink
        self.image = drinkImage
    }

    
    func downloadDrinkDetails() {
        downloadDrinkDetails { [weak self] drinkDetails, error in
            guard let drinkDetails = drinkDetails else {
                self?.onDownloadCompleted?(false, error)
                return
            }
            self?.details = drinkDetails.drinks.first
            self?.onDownloadCompleted?(true, error)
        }
    }
    
    private func downloadDrinkDetails(_ completion: @escaping (DrinkDetailsList?, Error?) -> Void) {
        networkService = NetworkManager()
        networkService?.getDrinkDetails(for: drink) { result in
            switch result {
            case .success(let drinkDetails):
                completion(drinkDetails, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
