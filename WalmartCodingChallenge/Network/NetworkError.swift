//
//  NetworkError.swift
//  WalmartCodingChallenge
//
//  Created by Remberto Nunez on 3/21/25.
//

import Foundation

enum NetworkError: Error {
    case responseFailure
    case invalidURL
    case urlError(Error)
    case decodingError(Error)
    case otherError(Error)
}
