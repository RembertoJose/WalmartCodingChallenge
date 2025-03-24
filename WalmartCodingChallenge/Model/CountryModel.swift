//
//  ContriesModel.swift
//  WalmartCodingChallenge
//
//  Created by Remberto Nunez on 3/21/25.
//

import Foundation

struct CountryModel: Decodable {
    struct Name: Decodable {
        let common: String
    }
    let name: Name
    let region: String?
    let cca2: String?
    let capital: [String]?

    var displayName: String { name.common }
    var displayRegion: String { region ?? "N/A" }
    var displayCode: String { cca2 ?? "N/A" }
    var displayCapital: String { capital?.first ?? "N/A" }
}
