//
//  MockNetworkController.swift
//  CashAppStocksTests
//
//  Created by Yariv on 7/7/22.
//

import Foundation
@testable import CashAppStocks

class MockNetworkController: NetworkController {
    let json: String

    init(json: String) {
        self.json = json
    }

    func get<DataType>(urlString: String, completion: @escaping (Result<DataType, NetworkError>) -> Void) where DataType : Decodable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let result = try decoder.decode(DataType.self, from: json.data(using: .utf8)!)
            completion(.success(result))
        } catch {
            completion(.failure(.JSONError(error)))
        }
    }
}
