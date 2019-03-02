//
//  CurrencyRates+augmented.swift
//  currency_converterTests
//
//  Created by HO Maxence (i-BP) on 02/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import XCTest

@testable import currency_converter

class CurrencyRatesAugmentedExtensionTests: XCTestCase
{
    /**
     * - When : calling `augmented:with_currencyInfoList:` from CurrencyRates instance
     * - Expects : the returned [AugmentedCurrencyRateBO] has the correct number of elements
     * - Expects : the returned [AugmentedCurrencyRateBO] contains the correct elements
     * - Expects : the returned [AugmentedCurrencyRateBO] have been properly augmented (i.e flag-image)
     */
    func test_augmentedWithCurrencyInfoList()
    {
        let rates =
            [ "JPY": 125.0
            , "USD": 1.13
            , "GBP": 0.89
            , "AUD": 1.6
            , "fail_case": 0
            ]
        
        let currencyInfoDict =
            [ "JPY": CurrencyInfo(code: "JPY", name: "test_JPY_name", symbol: "test_JPY_symbol")
            , "USD": CurrencyInfo(code: "USD", name: "test_USD_name", symbol: "test_USD_symbol")
            , "GBP": CurrencyInfo(code: "GBP", name: "test_GBP_name", symbol: "test_GBP_symbol")
            , "AUD": CurrencyInfo(code: "AUD", name: "test_AUD_name", symbol: "test_AUD_symbol")
            ]
        
        let currencyRates = CurrencyRates(base: "EUR", date: "test_date", rates: rates)
        let augmentedCurrencyRateList = currencyRates.augmented(with: currencyInfoDict)
        
        XCTAssert(augmentedCurrencyRateList.count == 4)
        
        let jyp_currencyInfo = augmentedCurrencyRateList.first(where: {
            $0.currencyInfo.currencyCode == "JPY"
        })
        XCTAssert(jyp_currencyInfo?.conversionRate == 125.0)
        
        let test_image = UIImage(
            named: "jpy",
            in: Bundle(for: CurrencyRatesAugmentedExtensionTests.self),
            compatibleWith: nil
        )
        XCTAssert(jyp_currencyInfo?.currencyInfo.flagImage.pngData() == test_image?.pngData())
    }
}
