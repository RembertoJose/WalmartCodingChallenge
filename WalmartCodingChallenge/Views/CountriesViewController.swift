//
//  ViewController.swift
//  WalmartCodingChallenge
//
//  Created by Remberto Nunez on 3/21/25.
//

import UIKit
import Combine

class CountriesViewController: UIViewController {
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let countriesViewModel = CountriesViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries"
        
        setupTableView()
        setupSearchController()
        setupViewModelBindings()
        
        countriesViewModel.getCountries()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CountryCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by Name or Capital"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupViewModelBindings() {
        countriesViewModel.$countries
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        countriesViewModel.$searchedCountries
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension CountriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesViewModel.numberOfCountries()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }
        let country = countriesViewModel.country(at: indexPath.row)
        cell.configure(with: country)
        return cell
    }
}

extension CountriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        countriesViewModel.isSearchActive = !text.isEmpty
        countriesViewModel.searchText = text
    }
}
