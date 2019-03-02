//
//  AugmentedCurrencyInfoBO.swift
//  currency_converterTests
//
//  Created by HO Maxence (i-BP) on 02/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import XCTest

@testable import currency_converter

class AugmentedCurrencyInfoBOTests: XCTestCase
{
    /**
     * - When : calling `AugmentedCurrencyInfoBO`'s Init with currencyInfoDict and currencyCode
     * - Expects : the returned `AugmentedCurrencyInfoBO` has the correct parameters (especially the flag image)
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
        
        XCTAssert(augmentedCurrencyInfo?.currencyCode == "AUD")
        XCTAssert(augmentedCurrencyInfo?.currencyFullname == "test_AUD_name")
        XCTAssert(augmentedCurrencyInfo?.symbol == "test_AUD_symbol")
        
        let test_image = UIImage(
            named: "aud",
            in: Bundle(for: AugmentedCurrencyInfoBOTests.self),
            compatibleWith: nil
        )
        XCTAssert(augmentedCurrencyInfo?.flagImage.pngData() == test_image?.pngData())
    }
}
