//
//  DrinkDetailsViewController.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 13/03/2023.
//

import UIKit

class DrinkDetailsViewController: UIViewController, Storyboarded {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var instructionsLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    weak var coordinator: MainCoordinator?
    
    private let spinner = SpinnerViewController()
    
    var viewModel: DrinkDetailsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Drink details view title", comment: "")
        
        setupSpinner()
        viewModel?.onDownloadCompleted = { downloaded, error in

            if downloaded {
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.titleLabel.text = self.viewModel?.details?.name
                    self.imageView.image = self.viewModel?.image
                    self.instructionsLabel.text = self.viewModel?.details?.instructions
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Data could not be loaded. Check your internet connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
                    self.downloadDetails()
                }))
                self.present(alert, animated: true)
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadDetails()
    }
    
    private func downloadDetails() {
        viewModel?.downloadDrinkDetails()
    }
    
    private func setupSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    private func removeSpinner() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
}
