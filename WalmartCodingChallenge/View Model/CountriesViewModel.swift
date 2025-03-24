//
//  ContriesViewModel.swift
//  WalmartCodingChallenge
//
//  Created by Remberto Nunez on 3/21/25.
//

import Foundation
import Combine

class CountriesViewModel {
    var countries: [CountryModel] = []
    var update: (() -> Void)?
    private var searchedCountries: [CountryModel] = []
    private let caller: DataCaller = NetworkManager()
    private let urlString = Constants.API.countriesURL
    private var cancellables = Set<AnyCancellable>()
    
    var isSearchActive: Bool = false {
        didSet { update?() }
    }
    
    func getCountries() {
        caller.fetchData(urlStr: urlString)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            }, receiveValue: { [weak self] country in
                self?.countries = country
                self?.update?()
            })
            .store(in: &cancellables)
    }
    
    func searchCountries(with searchText: String) {
        let lowercased = searchText.lowercased()
        searchedCountries = countries.filter {
            $0.displayName.lowercased().contains(lowercased) ||
            $0.displayCapital.lowercased().contains(lowercased)
        }
        update?()
    }
    
    func numberOfCountries() -> Int {
        return isSearchActive ? searchedCountries.count : countries.count
    }
    
    func country(at index: Int) -> CountryModel {
        return isSearchActive ? searchedCountries[index] : countries[index]
    }
}
