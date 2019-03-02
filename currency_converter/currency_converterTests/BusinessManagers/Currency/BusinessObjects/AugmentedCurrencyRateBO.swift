
//
//  AugmentedCurrencyRateBO.swift
//  currency_converterTests
//
//  Created by HO Maxence (i-BP) on 02/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import XCTest

@testable import currency_converter

class AugmentedCurrencyRateBOTests: XCTestCase
{
    /**
     * - When : calling `AugmentedCurrencyRateBO`'s Init with currencyInfoDict and currencyCode
     * - Expects : the returned `AugmentedCurrencyRateBO` has the correct parameters
     */
    func test_init()
    {
        let currencyInfoDict =
            [ "JPY": CurrencyInfo(code: "JPY", name: "test_JPY_name", symbol: "test_JPY_symbol")
            , "USD": CurrencyInfo(code: "USD", name: "test_USD_name", symbol: "test_USD_symbol")
            , "GBP": CurrencyInfo(code: "GBP", name: "test_GBP_name", symbol: "test_GBP_symbol")
            , "AUD": CurrencyInfo(code: "AUD", name: "test_AUD_name", symbol: "test_AUD_symbol")
            ]
        
        let augmentedCurrencyInfo = AugmentedCurrencyInfoBO(currencyCode: "AUD",
                                                            currencyInfoDict: currencyInfoDict)
        let augmentedCurrencyRate = AugmentedCurrencyRateBO(currencyCode: "AUD",
                                                            conversionRate: 1.0,
                                                            currencyInfoList: currencyInfoDict)
        
        XCTAssert(augmentedCurrencyRate?.currencyInfo == augmentedCurrencyInfo)
    }
}
