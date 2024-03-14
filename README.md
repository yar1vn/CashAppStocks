#  Cash Stocks App
by Yariv Nissim

## Architecture
This is a simple project using MVC.
For anything bigger I would use MVVM. I've used VIPER before but it felt too verbose.

MVC is nice to for simple screens but to avoid a Massive View Controller I broke the functionality into smaller controllers and components (Network, API, a few enums). 
We could break if even further by extending the State object to handle table view data source functions, having an extension on the API to return a State object,
 and eventually if we want full sepration switch to MVVM so the VM handles most of this functionality and the VC is just a simple view.
 This would also make the businless logic testable separately from the View layer.
 
## UI
I focused mostly on archiecture so the UI is pretty simple using a TableView and reusable cells.
There's support for pull-to-refresh and to change the API source to simulate empty and malformed responses using a menu.
The app supports dark mode and dynamic text sizes.

### Model
`Stock.swift` file contains a Codable version of Stock with an extension to format some of the data.

### View / ViewController
- `StocksViewController.swift` uses the `StocksAPI` class to load data and present it on screen.
It has a `State` enum to represent the various states based on the API response - default, empty and malformed.
- There's also a helper enum `APISource` to simluate different responses which we would usually not have in a production project (or maybe hiding in an internal test screen)

### Controller(s)
- `NetworkController` is a generic protocol to perform GET requests from a url endpoint and decode the returned JSON.
- It has as concrete implementation `NetworkControllerImpl` to perform actual network calls and a mock implementation `MockNetworkController` for unit test purposes

- `StocksAPI` is a protocol that represent the various API calls the app can perform.
- It takes a NetworkController using Dependency Injection so it can be unit tested, see `StockAPITests`.
- It has a few concrete implementations:
  - `StocksAPIImpl` uses the standard url that returns a valid response
  - `StocksAPIEmptyImpl` and `StocksAPIMalformedImpl` use other urls to simulate the other responses. 


## Trade offs
- I was using the Storyboard from the project template to save some time. We would probably set up the view controller in code and use the initializer to inject the StockAPI.
- I created multiple implementations of `StocksAPI` to keep the original protocol clean but another way could be to pass the url to the function or inject via init so that we could keep only a single concrete class.  
- The NumberFormatter inside `Stock.swift` is not thread-safe. It would probably need to be accessed via a DispatchQueue.sync as a possible solution.

## 3rd Party Libraries
None.

## How to run the project
Hit ⌘+R
