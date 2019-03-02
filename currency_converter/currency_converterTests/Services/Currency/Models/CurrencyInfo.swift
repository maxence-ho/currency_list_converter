//
//  CurrencyInfo.swift
//  currency_converterTests
//
//  Created by HO Maxence (i-BP) on 02/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import XCTest

@testable import currency_converter

class CurrencyInfoTests: XCTestCase
{
    /**
     * - When : creating `CurrencyInfo` instance from given json test file
     * - Expects : an instance of `CurrencyInfo` has effectively been created
     * - Expects : instance should contain the correct information (based on json)
     */
    func test_serialization()
    {
        guard
            let path = Bundle(for: CurrencyInfoTests.self).path(forResource: "test_getCurrencyInfo", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path),
                                 options: .mappedIfSafe),
            let currencyInfo = try? JSONDecoder().decode(CurrencyInfo.self,
                                                          from: data)
            else
        {
            XCTFail()
            return
        }

        XCTAssert(currencyInfo.code == "AUD")
        XCTAssert(currencyInfo.name == "Australian Dollar")
        XCTAssert(currencyInfo.symbol == "AUD$")
    }
}

class CurrencyListInfoTests: XCTestCase
{
    /**
     * - When : creating `CurrencyListInfo` instance from given json test file
     * - Expects : an instance of `CurrencyListInfo` has effectively been created
     * - Expects : instance should contain the correct information (based on json)
     */
    func test_serialization()
    {
        guard
            let path = Bundle(for: CurrencyInfoTests.self).path(forResource: "test_getCurrencyInfoList", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path),
                                 options: .mappedIfSafe),
            let currencyInfo = try? JSONDecoder().decode(CurrencyListInfo.self,
                                                         from: data)
            else
        {
            XCTFail()
            return
        }
        
        XCTAssert(currencyInfo.response.status == "OK")
        XCTAssert(currencyInfo.response.currencies.count == 61)
        XCTAssert(currencyInfo.response.currencies.first?.code == "AED")
    }
}
