//
//  CurrencyConverterPresenter.swift
//  currency_converterTests
//
//  Created by HO Maxence (i-BP) on 04/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import XCTest

@testable import currency_converter

class CurrencyConverterPresenterTests: XCTestCase
{
    func test_move()
    {
        let presenter = CurrencyConverterPresenter(view: nil)
        
        class Delegate: CurrencyRateCell
        {
            var updateCurrentCurrencyHasBeenCalled: (Bool, arg: CurrencyCode?) = (false, arg: nil)
            override func updateCurrentCurrency(newBaseCurrency: CurrencyCode)
            {
                updateCurrentCurrencyHasBeenCalled = (true, arg: newBaseCurrency)
            }
        }
        
        let currencyRate = AugmentedCurrencyRateBO(
            conversionRate: 0,
            currencyInfo: AugmentedCurrencyInfoBO(
                currencyCode: "test_currencyCode",
                currencyFullname: "test_currencyFullname",
                symbol: "test_symbol",
                flagImage: UIImage()
            )
        )
        presenter.currencyRatesDidChange(newCurrencyRates: [currencyRate])
        
        let delegate = Delegate()
        presenter.delegates.append(Weak(value: delegate))
        
        presenter.move(startIndex: 0, destinationIndex: 0)
        
        XCTAssert(delegate.updateCurrentCurrencyHasBeenCalled.0 == true)
        XCTAssert(delegate.updateCurrentCurrencyHasBeenCalled.arg == "test_currencyCode")
    }
}
