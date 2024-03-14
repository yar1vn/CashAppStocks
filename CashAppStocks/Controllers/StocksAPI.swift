//
//  APIController.swift
//  CashAppStocks
//
//  Created by Yariv on 7/6/22.
//

import Foundation

protocol StocksAPI {
    var networkController: NetworkController { get }
    func getStocks(completion: @escaping (Result<Stocks, NetworkError>) -> Void)
}

class StocksAPIImpl: StocksAPI {
    let networkController: NetworkController

    init(networkController: NetworkController = NetworkControllerImpl()) {
        self.networkController = networkController
    }

    func getStocks(completion: @escaping (Result<Stocks, NetworkError>) -> Void) {
        let url = "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio.json"
        networkController.get(urlString: url, completion: completion)
    }
}

// MARK: - Simulate empty and malformed responses

final class StocksAPIEmptyImpl: StocksAPIImpl {
    override func getStocks(completion: @escaping (Result<Stocks, NetworkError>) -> Void) {
        let url = "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio_empty.json"
        networkController.get(urlString: url, completion: completion)
    }
}

final class StocksAPIMalformedImpl: StocksAPIImpl {
    override func getStocks(completion: @escaping (Result<Stocks, NetworkError>) -> Void) {
        let url = "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio_malformed.json"
        networkController.get(urlString: url, completion: completion)
    }
}
