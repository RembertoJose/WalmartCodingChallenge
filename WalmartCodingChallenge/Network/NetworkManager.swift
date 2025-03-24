//
//  NetworkManager.swift
//  WalmartCodingChallenge
//
//  Created by Remberto Nunez on 3/21/25.
//

import Foundation
import Combine

protocol DataCaller {
    func fetchData<T: Decodable>(urlStr: String) -> AnyPublisher<T, Error>
}

class NetworkManager {
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
      self.session = session
    }
}

extension NetworkManager: DataCaller {
    func fetchData<T: Decodable>(urlStr: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlStr) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw NetworkError.responseFailure
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<T, Error> in
                if let urlError = error as? URLError {
                    return Fail(error: NetworkError.urlError(urlError)).eraseToAnyPublisher()
                } else if let decodingError = error as? DecodingError {
                    return Fail(error: NetworkError.decodingError(decodingError)).eraseToAnyPublisher()
                } else {
                    return Fail(error: NetworkError.otherError(error)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
