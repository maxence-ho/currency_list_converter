//
//  CurrencyRates.swift
//  currency_converterTests
//
//  Created by HO Maxence (i-BP) on 26/02/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import XCTest

@testable import currency_converter

class CurrencyRatesTests: XCTestCase
{
    /**
     * - When : creating `CurrencyRates` instance from given json test file
     * - Expects : an instance of `CurrencyRates` has effectively been created
     * - Expects : instance should contain the correct information (based on json)
     */
    func test_serialization()
    {
        guard
            let path = Bundle(for: CurrencyRatesTests.self).path(forResource: "test_getCurrencyRates_EUR", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path),
                                 options: .mappedIfSafe),
            let currencyRates = try? JSONDecoder().decode(CurrencyRates.self,
                                                          from: data)
        else
        {
            XCTFail()
            return
        }

        XCTAssert(currencyRates.base == "EUR")
        XCTAssert(currencyRates.rates.count == 32)
    }
}

