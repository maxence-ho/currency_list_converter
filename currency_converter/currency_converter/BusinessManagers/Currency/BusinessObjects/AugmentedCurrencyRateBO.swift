//
//  AugmentedCurrencyRates.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 01/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

/** Business Object - CurrencyInfo augmented by getting flag image for currency */
struct AugmentedCurrencyRateBO
{
    /** Conversion rate - based on a based currency */
    let conversionRate: Double
    /** Augmented currency information */
    let currencyInfo: AugmentedCurrencyInfoBO
}

extension AugmentedCurrencyRateBO
{
    /** Init - failable
     * parameter currencyCode: code of the currency
     * parameter conversionRate: conversion rate for the currency associated to `currencyCode`
     * parameter currencyInfoList: dictionary containing the currency information for each currency code
     */
    init?(currencyCode: CurrencyCode,
          conversionRate: Double,
          currencyInfoList: Dictionary<CurrencyCode, CurrencyInfo>)
    {
        guard
            let currencyInfo = AugmentedCurrencyInfoBO(currencyCode: currencyCode,
                                                       currencyInfoDict: currencyInfoList)
        else { return nil }
        
        self.conversionRate = conversionRate
        self.currencyInfo = currencyInfo
    }
}
