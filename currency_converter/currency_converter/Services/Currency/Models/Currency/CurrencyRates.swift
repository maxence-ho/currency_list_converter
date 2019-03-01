//
//  CurrencyRates.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 24/02/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

/** List of currency conversion rates for a base currency */
struct CurrencyRates: Codable
{
    var base: CurrencyCode
    var date: String
    var rates: [CurrencyCode:Double]
}
