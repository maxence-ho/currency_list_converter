//
//  CurrencyRouter.swift
//  currency_converterTests
//
//  Created by HO Maxence (i-BP) on 25/02/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import XCTest

@testable import currency_converter

class CurrencyRouterTests: XCTestCase
{
    /**
     * - When : calling `asURLRequest` from CurrencyRouter `getCurrencyRates` route
     * - Expects : request's url is properly generated
     * - Expects : http method to be `GET`
     */
    func test_asURLRequest()
    {
        let baseCurrency = "EUR"
        let currencyRoute = CurrencyRouter.getCurrencyRates(baseCurrencyCode: baseCurrency)
        XCTAssert(try currencyRoute.asURLRequest().urlRequest?.url?.absoluteString == "https://revolut.duckdns.org/latest?base=\(baseCurrency)")
        XCTAssert(try currencyRoute.asURLRequest().urlRequest?.httpMethod == "GET")
    }
}
