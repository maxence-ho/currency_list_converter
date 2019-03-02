//
//  CurrencyManager.swift
//  currency_converterTests
//
//  Created by HO Maxence (i-BP) on 02/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import XCTest
import Promises

@testable import currency_converter

class CurrencyManagerTests: XCTestCase
{
    
    /**
     * - When : calling `CurrencyManager`'s `startPolling`
     * - Expects : the polling task is created and calls `getCurrencyRates` each time it ticks
     */
    func test_init()
    {
        class CurrencyServiceProviderMock: CurrencyServiceProviderProtocol
        {
            var expectation: XCTestExpectation?
            func getCurrencyRates(baseCurrency: CurrencyCode) -> Promise<CurrencyRates>
            {
                XCTFail("getCurrencyRates should not be called")
                return Promise(GenericServiceError.responseWithoutData)
            }
            
            func getCurrencyListInfo() throws -> Dictionary<CurrencyCode, CurrencyInfo>
            {
                XCTAssert(true)
                expectation?.fulfill()
                return [:]
            }
        }
        
        let expectation = XCTestExpectation(description: "Wait getCurrencyListInfo call")
        let mockCurrencyServiceProvider = CurrencyServiceProviderMock()
        mockCurrencyServiceProvider.expectation = expectation
        
        _ = CurrencyManager(baseCurrency: "EUR",
                            currencyServiceProvider: mockCurrencyServiceProvider)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    /**
     * - When : calling `CurrencyManager`'s `startPolling`
     * - Expects : the polling task is created and calls `getCurrencyRates` each time it ticks
     */
    func test_startPolling()
    {
        class CurrencyServiceProviderMock: CurrencyServiceProviderProtocol
        {
            var expectation: XCTestExpectation?
            func getCurrencyRates(baseCurrency: CurrencyCode) -> Promise<CurrencyRates>
            {
                XCTAssert(baseCurrency == "EUR")
                expectation?.fulfill()
                let ret = CurrencyRates(base: "test_base", date: "test_date", rates: [:])
                return Promise(ret)
            }
            
            func getCurrencyListInfo() throws -> Dictionary<CurrencyCode, CurrencyInfo>
            {
                return [:]
            }
        }
        
        let expectation = XCTestExpectation(description: "Wait for polling first tick")
        let mockCurrencyServiceProvider = CurrencyServiceProviderMock()
        mockCurrencyServiceProvider.expectation = expectation
        
        let currencyManager = CurrencyManager(baseCurrency: "EUR",
                                              currencyServiceProvider: mockCurrencyServiceProvider)
        currencyManager?.startPolling()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    /**
     * - When : calling `CurrencyManager`'s `startPolling`
     * - Expects : the polling task is created and calls `getCurrencyRates` each time it ticks
     */
    func test_baseCurrency_didChange()
    {
        class CurrencyServiceProviderMock: CurrencyServiceProviderProtocol
        {
            var currentBaseCurrency: CurrencyCode = "EUR"
            var expectation: XCTestExpectation?
            func getCurrencyRates(baseCurrency: CurrencyCode) -> Promise<CurrencyRates>
            {
                XCTAssert(baseCurrency == currentBaseCurrency)
                expectation?.fulfill()
                let ret = CurrencyRates(base: "test_base", date: "test_date", rates: [:])
                return Promise(ret)
            }

            func getCurrencyListInfo() throws -> Dictionary<CurrencyCode, CurrencyInfo>
            {
                return [:]
            }
        }

        /** 1 - Start Polling - BaseCurrency = EUR -> expects getCurrencyRates to be called with EUR */
        let expectation_1 = XCTestExpectation(description: "Wait for polling first tick")
        let mockCurrencyServiceProvider = CurrencyServiceProviderMock()
        mockCurrencyServiceProvider.expectation = expectation_1

        let currencyManager = CurrencyManager(baseCurrency: "EUR",
                                              currencyServiceProvider: mockCurrencyServiceProvider)
        currencyManager?.startPolling()
        wait(for: [expectation_1], timeout: 2.0)
        
        /** 2 - baseCurrency changed - BaseCurrency = JPY -> expects getCurrencyRates to be called with JPY */
        let expectation_2 = XCTestExpectation(description: "Check that poll task has been recreated with the new base currency")
        mockCurrencyServiceProvider.expectation = expectation_2
        currencyManager?.baseCurrency = "JPY"
        mockCurrencyServiceProvider.currentBaseCurrency = "JPY"
        wait(for: [expectation_2], timeout: 2.0)
        
    }
    
    /**
     * - When : changing `CurrencyManager`'s `currencyRates` property
     * - Expects : the delegate is notified with the new value of `currencyRates`
     */
    func test_currencyRates_didChange()
    {
        let currencyManager = CurrencyManager(baseCurrency: "EUR")
        
        class TestListener: CurrencyManagerListener
        {
            var didReceiveNotification: (Bool, arg: [AugmentedCurrencyRateBO]?) = (false, arg: nil)
            func currencyRatesDidChange(newCurrencyRates: [AugmentedCurrencyRateBO])
            {
                self.didReceiveNotification = (true, arg: newCurrencyRates)
            }
        }
        
        let testListener = TestListener()
        currencyManager?.delegate = testListener
        
        let test_augmentedCurrencyInfoBO = AugmentedCurrencyInfoBO(
            currencyCode: "EUR",
            currencyFullname: "test_currencyFullname",
            symbol: "test_symbol",
            flagImage: UIImage()
        )
        let test_augmentedCurrencyRateBO = AugmentedCurrencyRateBO(
            conversionRate: 1.0,
            currencyInfo: test_augmentedCurrencyInfoBO
        )
        currencyManager?.currencyRates = [test_augmentedCurrencyRateBO]
        
        XCTAssert(testListener.didReceiveNotification.0 == true)
        XCTAssert(testListener.didReceiveNotification.arg?.count == 1)
        XCTAssert(testListener.didReceiveNotification.arg?.first == test_augmentedCurrencyRateBO)
    }
}
