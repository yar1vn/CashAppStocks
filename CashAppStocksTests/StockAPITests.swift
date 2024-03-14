//
//  StockAPITests.swift
//  CashAppStocksTests
//
//  Created by Yariv on 7/6/22.
//

import XCTest
@testable import CashAppStocks

class StockAPITests: XCTestCase {
    func testStocksAPI_Success() {
        StocksAPIImpl(networkController: MockNetworkController(json: stocksJSON))
            .getStocks { result in
                do {
                    let stocks = try result.get().stocks
                    XCTAssertGreaterThan(stocks.count, 0)
                    XCTAssertEqual(stocks.first?.ticker, "TWTR")
                } catch {
                    XCTFail()
                }
            }
    }

    func testStocksAPI_Empty() {
        StocksAPIImpl(networkController: MockNetworkController(json: stocksEmptyJSON))
            .getStocks { result in
                do {
                    let stocks = try result.get().stocks
                    XCTAssertEqual(stocks.count, 0)
                } catch {
                    XCTFail()
                }
            }
    }

    func testStocksAPI_Malformed() {
        StocksAPIImpl(networkController: MockNetworkController(json: stocksMalformedJSON))
            .getStocks { result in
                do {
                    _ = try result.get().stocks
                    XCTFail()
                } catch {
                    guard case NetworkError.JSONError = error else {
                        return XCTFail()
                    }
                }
            }
    }
}

// MARK: - Hardcoded json responses from the endpoints

private let stocksJSON =
"""
{"stocks":[{"ticker":"TWTR","name":"Twitter, Inc.","currency":"USD","current_price_cents":3833,"quantity":null,"current_price_timestamp":1636657688},{"ticker":"^GSPC","name":"S&P 500","currency":"USD","current_price_cents":318157,"quantity":25,"current_price_timestamp":1636657688},{"ticker":"RUNINC","name":"Runners Inc.","currency":"USD","current_price_cents":3614,"quantity":5,"current_price_timestamp":1636657688},{"ticker":"BAC","name":"Bank of America Corporation","currency":"USD","current_price_cents":2393,"quantity":10,"current_price_timestamp":1636657688},{"ticker":"EXPE","name":"Expedia Group, Inc.","currency":"USD","current_price_cents":8165,"quantity":null,"current_price_timestamp":1636657688},{"ticker":"GRUB","name":"Grubhub Inc.","currency":"USD","current_price_cents":6975,"quantity":null,"current_price_timestamp":1636657688},{"ticker":"TRUNK","name":"Trunk Club","currency":"USD","current_price_cents":17632,"quantity":9,"current_price_timestamp":1636657688},{"ticker":"FIT","name":"Fitbit, Inc.","currency":"USD","current_price_cents":678,"quantity":2,"current_price_timestamp":1636657688},{"ticker":"UA","name":"Under Armour, Inc.","currency":"USD","current_price_cents":844,"quantity":7,"current_price_timestamp":1636657688},{"ticker":"VTI","name":"Vanguard Total Stock Market Index Fund ETF Shares","currency":"USD","current_price_cents":15994,"quantity":null,"current_price_timestamp":1636657688},{"ticker":"RUN","name":"Run","currency":"USD","current_price_cents":6720,"quantity":12,"current_price_timestamp":1636657688},{"ticker":"VWO","name":"Vanguard FTSE Emerging Markets","currency":"USD","current_price_cents":4283,"quantity":null,"current_price_timestamp":1636657688},{"ticker":"JNJ","name":"Johnson & Johnson","currency":"USD","current_price_cents":14740,"quantity":null,"current_price_timestamp":1636657688},{"ticker":"BRKA","name":"Berkshire Hathaway Inc.","currency":"USD","current_price_cents":28100000,"quantity":1,"current_price_timestamp":1636657688},{"ticker":"^DJI","name":"Dow Jones Industrial Average","currency":"USD","current_price_cents":2648154,"quantity":null,"current_price_timestamp":1636657688},{"ticker":"^TNX","name":"Treasury Yield 10 Years","currency":"USD","current_price_cents":61,"quantity":10,"current_price_timestamp":1636657688},{"ticker":"RUNWAY","name":"Rent The Runway","currency":"USD","current_price_cents":24819,"quantity":null,"current_price_timestamp":1636657688}]}
"""

private let stocksEmptyJSON =
"""
{"stocks":[]}

"""

private let stocksMalformedJSON =
"""
{"stocks":[{"ticker":"TWTR","name":"Twitter, Inc.","currency":"USD","current_price_cents":3833,"quantity":null,"current_price_timestamp":1636657688},{"ticker":"^GSPC","name":"S&P 500","currency":"USD","current_price_cents":318157,"quantity":25,"current_price_timestamp":1636657688},{"ticker":"RUNINC","name":"Runners Inc.","currency":"USD","current_price_cents":3614,"quantity":5,"current_price_timestamp":1636657688},{"ticker":"BAC","name":"Bank of America Corporation","currency":"USD","current_price_cents":2393,"quantity":10,"current_price_timestamp":1636657688},{"ticker":"EXPE","name":"Expedia Group, Inc.","currency":"USD","current_price_cents":8165,"quantity":null,"current_price_timestamp":1636657688},{"ticker":"GRUB","name":"Grubhub Inc.","currency":"USD","current_price_cents":6975,"quantity":null,"current_price_timestamp":1636657688},{"ticker":"TRUNK","name":"Trunk Club","currency":"USD","current_price_cents":17632,"quantity":9,"current_price_timestamp":1636657688},{"ticker":"FIT","name":"Fitbit, Inc.","currency":"USD","current_price_cents":678,"quantity":2,"current_price_timestamp":1636657688},{"ticker":"UA","name":"Under Armour, Inc.","currency":"USD","current_price_cents":844,"quantity":7,"current_price_timestamp":1636657688},{"ticker":"VTI","name":"Vanguard Total Stock Market Index Fund ETF Shares","currency":"USD","current_price_cents":15994,"quantity":null,"current_price_timestamp":1636657688},{"ticker":"RUN","name":"Run","currency":"USD","current_price_cents":6720,"quantity":12,"current_price_timestamp":1636657688},{"ticker":"VWO","name":"Vanguard FTSE Emerging Markets","currency":"USD","current_price_cents":4283,"quantity":null,"current_price_timestamp":1636657688},{"ticker":"JNJ","name":"Johnson & Johnson","currency":"USD","current_price_cents":14740,"quantity":null,"current_price_timestamp":1636657688},{"ticker":"BRKA","name":"Berkshire Hathaway Inc.","currency":"USD","current_price_cents":28100000,"quantity":1,"current_price_timestamp":1636657688},{"ticker":"^DJI","name":"Dow Jones Industrial Average","currency":"USD","current_price_cents":2648154,"quantity":null,"current_price_timestamp":1636657688},{"ticker":"^TNX","name":"Treasury Yield 10 Years","currency":"USD","current_price_cents":61,"quantity":10,"current_price_timestamp":1636657688},{"ticker":"RUNWAY","name":"Rent The Runway","currency":"USD","current_price_cents":24819,"quantity":null,"current_price_timestamp":1636657688}]}malformedmalformedmalformed
"""
