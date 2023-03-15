//
//  SearchDrinkViewController.swift
//  BeverageApp
//
//  Created by Maciej Adamczyk on 13/03/2023.
//

import UIKit

class SearchDrinkViewController: UIViewController, Storyboarded {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let reuseCellIdentifier = "ReusableTableCell"
    private var searchController: UISearchController!
    private var ingredients: [Ingredient] = []
    private var filteredIngredients: [Ingredient] = []
    private let spinner = SpinnerViewController()

    weak var coordinator: MainCoordinator?
    
    var viewModel: SearchDrinkViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Ingredients view title", comment: "")
        setupSpinner()
        viewModel?.onDownloadCompleted = { downloaded, error in

            if downloaded, let ingredients = self.viewModel?.drinkIngredients?.ingredients {
                self.ingredients = ingredients
                self.filteredIngredients = ingredients
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.tableView.reloadData()
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Data could not be loaded. Check your internet connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
                    self.downloadIngredients()
                }))
                self.present(alert, animated: true)
            }
        }
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = NSLocalizedString("SearchBar placeholder", comment: "")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadIngredients()
    }
    
    private func downloadIngredients() {
        viewModel?.setupIngredients()
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

// MARK: - Search controller extensions

extension SearchDrinkViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredIngredients = searchText.isEmpty ? ingredients : ingredients.filter({(ingredient: Ingredient) -> Bool in
                return ingredient.name.range(of: searchText, options: .caseInsensitive) != nil
            })
            tableView.reloadData()
        }
    }
}

// MARK: - UITableView extensions


extension SearchDrinkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier)!
        cell.textLabel?.text = filteredIngredients[indexPath.row].name
        return cell
    }
}

extension SearchDrinkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = ingredients[indexPath.row]
        coordinator?.showDrinksCollectionView(with: ingredient)
    }
}
