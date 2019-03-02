//
//  CurrencyServiceProvider.swift
//  currency_converterTests
//
//  Created by HO Maxence (i-BP) on 02/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import XCTest

@testable import currency_converter

class CurrencyServiceProviderTests: XCTestCase
{
    /**
     * - When : calling `getCurrencyListInfo` from CurrencyServiceProvider (call is mocked and fetch in JSON file)
     * - Expects : a `CurrencyListInfo` instance has been created woth the correct parameters
     */
    func test_getCurrencyListInfo()
    {
        let currencyListInfo = try? CurrencyServiceProvider().getCurrencyListInfo()
        XCTAssert(currencyListInfo != nil)
        XCTAssert(currencyListInfo?.count == 61)
        XCTAssert(currencyListInfo?["USD"]?.name == "United States Dollar")
    }
}
