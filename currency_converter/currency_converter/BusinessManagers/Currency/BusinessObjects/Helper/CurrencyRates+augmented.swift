//
//  CurrencyRates+augmented.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 01/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

extension CurrencyRates
{
    /** Fonction that augments a `CurrencyRates` instance with information from a list of `CurrencyInfo`
     * parameter currencyInfoList: list of CurrencyInfo used to augmend `CurrencyRates` information
     * returns: augmented currency rates as [AugmentedCurrencyRateBO]
     */
    func augmented(with currencyInfoList: Dictionary<CurrencyCode, CurrencyInfo>) -> [AugmentedCurrencyRateBO]
    {
        return self.rates
            .map { (currencyCode: CurrencyCode, conversionRate: Double) -> AugmentedCurrencyRateBO? in
                return AugmentedCurrencyRateBO(currencyCode: currencyCode,
                                               conversionRate: conversionRate,
                                               currencyInfoList: currencyInfoList)
            }
            .compactMap { $0 }
    }
}
