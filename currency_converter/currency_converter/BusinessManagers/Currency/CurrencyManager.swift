//
//  CurrencyManager.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 01/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

/** Protocol used to listen to CurrencyManager and act upon notification - delegate pattern */
protocol CurrencyManagerListener: class {
    /** Delegate method to implement to manage notifications */
    func currencyRatesDidChange(newCurrencyRates: [AugmentedCurrencyRateBO])
}

/** Class that can continuously fetch AugmentedCurrencyRates relative to a base
 * currency. Classes can implement the delegate protocol above to be notified
 * when the currency rates are updated.
 */
class CurrencyManager
{
    /** Used for unit tests */
    private let currencyServiceProvider: CurrencyServiceProviderProtocol
    
    /** List of currency information that is fetched from a mocked service - embedded json file */
    private let currencyInfoDict: Dictionary<CurrencyCode, CurrencyInfo>
    
    /** Polling task used by the manager to fetch CurrencyRates periodically */
    private var pollTask: PollAsyncTask<CurrencyRates>?
    
    /** List of listeners that will be notified when `currencyRates` changes */
    weak var delegate: CurrencyManagerListener?
    
    /** Base currency used that acts as reference for the conversion rates */
    var baseCurrency: CurrencyCode {
        /** Upon changing the base currency, we replace the polling task by one
         * requesting data with the new base currency
         */
        didSet {
            self.pollTask = nil
            let requestFactory = RequestFactory(
                getRequest: { [unowned self] in
                    return self.currencyServiceProvider.getCurrencyRates(baseCurrency: self.baseCurrency)
                }
            )
            self.configurePolling(withRequestFactory: requestFactory)
        }
    }
    
    /** Up to date currency rates based on the base currency */
    var currencyRates: [AugmentedCurrencyRateBO] = [] {
        /** Upon changing the currencyRates, we notify the delegate that this
         * value has changed and pass the new value
         */
        didSet {
            delegate?.currencyRatesDidChange(newCurrencyRates: self.currencyRates)
        }
    }

    /** Init - failable.
     * parameter baseCurrency: code of the base currency
     */
    init?(baseCurrency: CurrencyCode, currencyServiceProvider: CurrencyServiceProviderProtocol? = nil)
    {
        self.currencyServiceProvider = currencyServiceProvider ?? CurrencyServiceProvider()
        guard
            let fetchedCurrencyInfoDict = try? self.currencyServiceProvider.getCurrencyListInfo()
        else { return nil}
        
        self.baseCurrency = baseCurrency
        /** Fetches the currency info list from the mocked service */
        self.currencyInfoDict = fetchedCurrencyInfoDict
    }
}

extension CurrencyManager
{
    /** Function that create and activate the manager's polling task */
    func startPolling()
    {
        let requestFactory = RequestFactory(
            getRequest: { [unowned self] in
                return self.currencyServiceProvider.getCurrencyRates(baseCurrency: self.baseCurrency)
            }
        )
        configurePolling(withRequestFactory: requestFactory)
    }
    
    /** Function that configure the manager's `pollTask` then start the polling timer
     * parameter requestFactory: factory that produces the request for the poll task
     */
    private func configurePolling(withRequestFactory requestFactory: RequestFactory<CurrencyRates>)
    {
        self.pollTask = PollAsyncTask(requestFactory: requestFactory,
                                      completion: { [unowned self] in
                                        self.currencyRates = $0.augmented(with: self.currencyInfoDict)
                                      },
                                      interval: 1)
        self.pollTask?.start()
    }
}
