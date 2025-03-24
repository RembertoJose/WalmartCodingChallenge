//
//  CountriesViewModel.swift
//  WalmartCodingChallenge
//
//  Created by Remberto Nunez on 3/21/25.
//

import Foundation
import Combine

class CountriesViewModel: ObservableObject {
    @Published private(set) var countries: [CountryModel] = []
    @Published private(set) var searchedCountries: [CountryModel] = []
    @Published var isSearchActive: Bool = false
    @Published var searchText: String = ""
    
    private let caller: DataCaller
    private let urlString = Constants.API.countriesURL
    private var cancellables = Set<AnyCancellable>()
    
    init(caller: DataCaller = NetworkManager()) {
        self.caller = caller
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.filterCountries(with: text)
            }
            .store(in: &cancellables)
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
            })
            .store(in: &cancellables)
    }
    
    private func filterCountries(with searchText: String) {
        let lowercased = searchText.lowercased()
        searchedCountries = countries.filter {
            $0.displayName.lowercased().contains(lowercased) ||
            $0.displayCapital.lowercased().contains(lowercased)
        }
    }
    
    func numberOfCountries() -> Int {
        return isSearchActive ? searchedCountries.count : countries.count
    }
    
    func country(at index: Int) -> CountryModel {
        return isSearchActive ? searchedCountries[index] : countries[index]
    }
}
