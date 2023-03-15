//
//  DrinksCollectionViewController.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 15/03/2023.
//

import UIKit

class DrinksCollectionViewController: UIViewController, Storyboarded {

    @IBOutlet private weak var collectionView: UICollectionView!
    private let reuseCellIdentifier = "ReusableCollectionCell"

    weak var coordinator: MainCoordinator?
    private let spinner = SpinnerViewController()
    private var drinks: [Drink] = []
    private var drinksImages: [UIImage] = []

    var viewModel: DrinksCollectionViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Drinks view title", comment: "")
        setupSpinner()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DrinksCollectionCell.self, forCellWithReuseIdentifier: reuseCellIdentifier)
        
        viewModel?.onDownloadCompleted = { downloaded, error in

            if downloaded, let drinks = self.viewModel?.drinks, let drinksImages = self.viewModel?.drinksImages {
                self.drinks = drinks
                self.drinksImages = drinksImages
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.collectionView.reloadData()
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Data could not be loaded. Check your internet connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
                    self.getDrinks()
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDrinks()
    }
    
    private func getDrinks() {
        viewModel?.downloadDrinks()
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

// MARK: - UICollectionView extensions

extension DrinksCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.showDetailsView(for: drinks[indexPath.item], withImage: drinksImages[indexPath.item])
    }
}

extension DrinksCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier, for: indexPath) as! DrinksCollectionCell
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 10.0
        cell.drinkImage = drinksImages[indexPath.row]
        cell.drink = drinks[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinks.count
    }
}

extension DrinksCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.height/2)
    }
}
