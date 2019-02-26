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
     * Currency service endpoint to get the currency rates for a given base currency
     * - parameters baseCurrrency: base currency which rates are requested
     * - returns: currency rates (relative to the base currency) as `CurrencyRate`
     */
    static func getCurrencyRates(baseCurrency: CurrencyCode) -> Promise<CurrencyRates>
}

/** Class used as namespace to contain all the endpoints related to currency requests */
class CurrencyServiceProvider: CurrencyServiceProviderProtocol
{
    /**
     * Currency service endpoint to get the currency rates for a given base currency
     * - parameters baseCurrrency: base currency which rates are requested
     * - returns: currency rates (relative to the base currency) as `CurrencyRates`
     */
    static func getCurrencyRates(baseCurrency: CurrencyCode) -> Promise<CurrencyRates>
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
                .responseJSON { response in
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
}
