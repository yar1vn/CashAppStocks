//
//  Stock.swift
//  CashAppStocks
//
//  Created by Yariv on 7/6/22.
//

import Foundation

struct Stock: Codable {
    let ticker: String
    let name: String
    let currency: String
    let currentPriceCents: Int
    let quantity: Int?
    let currentPriceTimestamp: Int
}

extension Stock {
    var currentPriceDate: Date {
        Date(timeIntervalSince1970: TimeInterval(currentPriceTimestamp))
    }

    // This probably needs to be put inside a thread-safe container.
    // Possibly using a custom DispatchQueue w/ sync calls
    private static let currencyFormatter = NumberFormatter()

    var currentPrice: String? {
        Self.currencyFormatter.currencyCode = currency
        Self.currencyFormatter.numberStyle = .currency

        return Self.currencyFormatter.string(from: NSNumber(value: Double(currentPriceCents) / 100))
    }
}

struct Stocks: Codable {
    let stocks: [Stock]
}
