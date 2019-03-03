//
//  CurrencyServiceProvider.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 24/02/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import Alamofire
import Promises

protocol CurrencyServiceProviderProtocol
{
    /**
     Currency service endpoint to get the currency rates for a given base currency
     
     - parameters:
        - baseCurrrency: base currency which rates are requested
     - returns: currency rates (relative to the base currency) as `CurrencyRates`
     */
    func getCurrencyRates(baseCurrency: CurrencyCode) -> Promise<CurrencyRates>
    
    /**
     Mocked Currency service endpoint to get the currencies information
     
     - returns: currency list information as Dictionary<CurrencyCode, CurrencyInfo> so that find access is cheap
     */
    func getCurrencyListInfo() throws -> Dictionary<CurrencyCode, CurrencyInfo>
}

/** Class used as namespace to contain all the endpoints related to currency requests */
class CurrencyServiceProvider: CurrencyServiceProviderProtocol
{
    let queue = DispatchQueue(label: "currency_manager_queue", qos: .background)
    
    /**
     Currency service endpoint to get the currency rates for a given base currency
     
     - parameters:
        - baseCurrrency: base currency which rates are requested
        - returns: currency rates (relative to the base currency) as `CurrencyRates`
     */
    func getCurrencyRates(baseCurrency: CurrencyCode) -> Promise<CurrencyRates>
    {
        guard let request = try? CurrencyRouter
            .getCurrencyRates(baseCurrencyCode: baseCurrency)
            .asURLRequest()
        else
        {
            return Promise(CurrencyServiceError.generatingRequestURLError)
        }
        
        return Promise<CurrencyRates> { fulfill, reject in
            Alamofire
                .request(request)
                .validate()
                .responseJSON(queue: self.queue) { response in
                    switch response.result
                    {
                    case .success:
                        do
                        {
                            guard
                                let data = response.data
                            else
                            {
                                throw GenericServiceError.responseWithoutData
                            }
                            let currencyRates = try JSONDecoder().decode(CurrencyRates.self,
                                                                         from: data)
                            fulfill(currencyRates)
                        }
                        catch let error
                        {
                            reject(error)
                            print("getCurrencyRates - Error - \(error)")
                        }
                    case .failure(let error):
                        reject(error)
                        print("getCurrencyRates - Error - \(error)")
                    }
                }
        }
    }
    
    /**
     Mocked Currency service endpoint to get the currencies information
     - returns: currency list information as Dictionary<CurrencyCode, CurrencyInfo> so that find access is cheap
     */
    func getCurrencyListInfo() throws -> Dictionary<CurrencyCode, CurrencyInfo>
    {
        guard let path = Bundle.main.path(forResource: "getCurrencyInfoList", ofType: "json")
        else { throw CurrencyServiceError.mockedResourcedSearchFailed }
    
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let currencyInfoList = try JSONDecoder().decode(CurrencyListInfo.self, from: data)
        let currencyTupleList = currencyInfoList.response.currencies.map({ currency in
            (currency.code, currency)
        })
        return Dictionary(currencyTupleList, uniquingKeysWith: { first, _ in first })
    }
}
