//
//  WalmartCodingChallengeUnitTests.swift
//  WalmartCodingChallengeUnitTests
//
//  Created by Remberto Nunez on 3/23/25.
//

import XCTest
import Combine
@testable import WalmartCodingChallenge

final class WalmartCodingChallengeUnitTests: XCTestCase {
    var viewModel: CountriesViewModel!
    var mockCaller: MockDataCaller!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockCaller = MockDataCaller()
        viewModel = CountriesViewModel(caller: mockCaller)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockCaller = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testGetCountriesSuccess() {
        // Given
        let expectedCountries = [
            CountryModel(
                capital: "Paris",
                code: "FR",
                currency: Currency(code: "EUR", name: "Euro", symbol: "€"),
                flag: "",
                language: Language(code: "fr", name: "French"),
                name: "France",
                region: "EU"
            ),
            CountryModel(
                capital: "Tokyo",
                code: "JP",
                currency: Currency(code: "JPY", name: "Yen", symbol: "¥"),
                flag: "",
                language: Language(code: "ja", name: "Japanese"),
                name: "Japan",
                region: "AS"
            )
        ]
        
        mockCaller.publisher = Just(expectedCountries)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "Countries fetched")

        viewModel.$countries
            .dropFirst()
            .sink { countries in
                XCTAssertEqual(countries.count, 2)
                XCTAssertEqual(countries[0].name, "France")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // When
        viewModel.getCountries()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSearchCountries() {
        // Given
        let expectedCountries = [
            CountryModel(
                capital: "Tokyo",
                code: "JP",
                currency: Currency(code: "JPY", name: "Yen", symbol: "¥"),
                flag: "",
                language: Language(code: "ja", name: "Japanese"),
                name: "Japan",
                region: "AS"
            ),
            CountryModel(
                capital: "Berlin",
                code: "DE",
                currency: Currency(code: "EUR", name: "Euro", symbol: "€"),
                flag: "",
                language: Language(code: "de", name: "German"),
                name: "Germany",
                region: "EU"
            )
        ]

        mockCaller.publisher = Just(expectedCountries)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "Search countries filtered")
        
        viewModel.$searchedCountries
            .dropFirst()
            .sink { searched in
                XCTAssertEqual(searched.count, 1)
                XCTAssertEqual(searched[0].name, "Germany")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.getCountries()

        viewModel.$countries
            .dropFirst()
            .sink { _ in
                self.viewModel.isSearchActive = true
                self.viewModel.searchText = "ger"
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}

class MockDataCaller: DataCaller {
    var publisher: AnyPublisher<[CountryModel], Error> = Just([])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    
    func fetchData<T>(urlStr: String) -> AnyPublisher<T, Error> where T : Decodable {
        return publisher as! AnyPublisher<T, Error>
    }
}
