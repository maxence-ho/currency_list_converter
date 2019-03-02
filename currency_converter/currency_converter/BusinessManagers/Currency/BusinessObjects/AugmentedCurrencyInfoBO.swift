//
//  CurrencyInfo.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 01/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import UIKit

/** Business Object - CurrencyInfo augmented by getting flag image for currency */
struct AugmentedCurrencyInfoBO: Equatable
{
    /** String representing the currency code
     *  ex: USD
     */
    let currencyCode: CurrencyCode
    /** String representing the currency symbol
     *  ex: United States Dollar
     */
    let currencyFullname: String
    /** String representing the currency symbol
     *  ex: $
     */
    let symbol: String
    /** UIImage representing the currency associated flag */
    let flagImage: UIImage
}

extension AugmentedCurrencyInfoBO
{
    /** Init - failable
     * parameter currencyCode: code of the currency we want the info
     * parameter currencyInfoDict: dictionary containing the currency information for each currency code
     */
    init?(currencyCode: CurrencyCode,
          currencyInfoDict: Dictionary<CurrencyCode, CurrencyInfo>)
    {
        guard
            let currencyInfo = currencyInfoDict[currencyCode],
            let flagImage = UIImage(named: currencyCode.lowercased())
        else { return nil }
        
        self.currencyCode = currencyCode
        self.currencyFullname = currencyInfo.name
        self.symbol = currencyInfo.symbol
        self.flagImage = flagImage
    }
}
