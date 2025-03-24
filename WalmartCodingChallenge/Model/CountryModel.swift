//
//  ContriesModel.swift
//  WalmartCodingChallenge
//
//  Created by Remberto Nunez on 3/21/25.
//

import Foundation

struct CountryModel: Decodable {
    let capital: String?
    let code: String?
    let currency: Currency?
    let flag: String?
    let language: Language?
    let name: String?
    let region: String?

    var displayName: String {
        name ?? "N/A"
    }
    var displayRegion: String {
        region ?? "N/A"
    }
    var displayCode: String {
        code ?? "N/A"
    }
    var displayCapital: String {
        capital ?? "N/A"
    }
}

struct Currency: Decodable {
    let code: String?
    let name: String?
    let symbol: String?
}

struct Language: Decodable {
    let code: String?
    let name: String?
}


