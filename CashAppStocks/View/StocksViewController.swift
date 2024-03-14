//
//  StocksViewController.swift
//  CashAppStocks
//
//  Created by Yariv on 7/6/22.
//

import UIKit

// MARK: - APISource -

/// This enum is used for simulating different api responses
private enum APISource: String, CaseIterable {
    case `default`
    case empty
    case malformed

    func getSource() -> StocksAPI {
        switch self {
        case .default: return StocksAPIImpl()
        case .empty: return StocksAPIEmptyImpl()
        case .malformed: return StocksAPIMalformedImpl()
        }
    }

    func createAction(currentSource: APISource, handler: @escaping UIActionHandler) -> UIAction {
        .init(title: self.rawValue.localizedCapitalized,
              state: currentSource == self ? .on : .off,
              handler: handler)
    }
}

// MARK: - State -

/// This enum handles the state of the view controller based on the api response
private enum State {
    case `default`([Stock])
    case empty
    case error(NetworkError)

    init(_ stocks: [Stock]) {
        if stocks.isEmpty { self = .empty }
        else { self = .default(stocks) }
    }

    var count: Int {
        switch self {
        case .default(let stocks): return stocks.count
        default: return 0
        }
    }
}

// MARK: - StocksViewController -

final class StocksViewController: UITableViewController {
    private var state: State = .empty {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateEmptyOrErrorState()
            }
        }
    }

    private lazy var api: StocksAPI = StocksAPIImpl()

    private var apiSource = APISource.default {
        didSet {
            api = apiSource.getSource()
            fetchStocks()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        createSourceMenu()
        setupRefreshControl()
        fetchStocks()
    }

    private func createSourceMenu() {
        let menu = UIMenu(title: "API Source",
                          children: APISource.allCases.map { selectedSource in
            selectedSource.createAction(currentSource: apiSource) { [unowned self] _ in
                self.apiSource = selectedSource
                createSourceMenu() // update the menu to reflect the current selection
            }
        })

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: apiSource.rawValue.localizedCapitalized, menu: menu)
    }

    private func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(fetchStocks),
                                            for: .valueChanged)
    }

    @objc private func fetchStocks() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.beginRefreshing()
        }

        api.getStocks { result in
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }

            do {
                self.state = State(try result.get().stocks)
            } catch {
                // `Result.get()` throws a generic error so we'll need to cast is back to NetworkError
                self.state = .error(error as! NetworkError)
            }
        }
    }

    private func updateEmptyOrErrorState() {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center

        switch state {
        case .empty:
            label.text = "📉\nThe server returned no stocks"
            tableView.backgroundView = label
        case .error(let error):
            label.text = "📈\nThe server returned an error:\n\n\(error)"
            tableView.backgroundView = label
        case .default:
            tableView.backgroundView = nil
        }
    }
}

// MARK: - UITableViewDataSource -

extension StocksViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        state.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath)

        guard case .default(let stocks) = state else {
            return cell
        }
        let stock = stocks[indexPath.row]
        cell.textLabel?.text = "\(stock.name) (\(stock.ticker))"

        if let currentPrice = stock.currentPrice {
            let date = DateFormatter.localizedString(from: stock.currentPriceDate,
                                                     dateStyle: .medium, timeStyle: .none)
            cell.detailTextLabel?.text = "\(currentPrice) on \(date)"
        } else {
            // We could potentially hide a cell without price information
            cell.detailTextLabel?.text = "(Price is missing)"
        }

        return cell
    }
}
