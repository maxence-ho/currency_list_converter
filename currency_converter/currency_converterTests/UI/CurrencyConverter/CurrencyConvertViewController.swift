//
//  CurrencyConvertViewController.swift
//  currency_converterTests
//
//  Created by HO Maxence (i-BP) on 04/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import XCTest

@testable import currency_converter

class CurrencyConverterViewControllerTests: XCTestCase
{
    func test_viewDidLoad()
    {
        class MockPresenter: CurrencyConverterPresenterProtocol
        {
            var configureHasBeenCalled = false
            func configure()
            {
                configureHasBeenCalled = true
            }
            
            func numberOfCurrency() -> Int
            {
                return 0
            }
            
            func getCurrencyRate(forRow row: Int) -> AugmentedCurrencyRateBO?
            {
                return nil
            }
            
            func move(startIndex: Int, destinationIndex: Int) {}
            
            func updateAmountToConvert(_ newAmount: Double) {}
            
            func getCurrentBaseCurrency() -> CurrencyCode
            {
                return ""
            }
        }
        
        let view = CurrencyConverterViewController()
        let tableView = UITableView()
        view.tableView = tableView
        let presenter = MockPresenter()
        
        view.presenter = presenter
        
        view.viewDidLoad()
        
        XCTAssert(presenter.configureHasBeenCalled == true)
    }
    
    func test_textFieldDidChange()
    {
        class MockPresenter: CurrencyConverterPresenterProtocol
        {
            var updateAmountToConvertHasBeenCalled: (Bool, arg: Double?) = (false, arg: nil)
            
            func configure() {}
            
            func numberOfCurrency() -> Int
            {
                return 0
            }
            
            func getCurrencyRate(forRow row: Int) -> AugmentedCurrencyRateBO?
            {
                return nil
            }
            
            func move(startIndex: Int, destinationIndex: Int) {}
            
            func updateAmountToConvert(_ newAmount: Double)
            {
                updateAmountToConvertHasBeenCalled = (true, arg: newAmount)
            }
            
            func getCurrentBaseCurrency() -> CurrencyCode
            {
                return ""
            }
        }
        
        let view = CurrencyConverterViewController()
        let tableView = UITableView()
        view.tableView = tableView
        let presenter = MockPresenter()
        
        view.presenter = presenter
        
        let textField_1 = UITextField()
        textField_1.text = "not_a_double"
        view.textFieldDidChange(textField: textField_1)
        XCTAssert(presenter.updateAmountToConvertHasBeenCalled.0 == false)
      
        let textField_2 = UITextField()
        textField_2.text = ""
        view.textFieldDidChange(textField: textField_2)
        XCTAssert(presenter.updateAmountToConvertHasBeenCalled.0 == true)
        XCTAssert(presenter.updateAmountToConvertHasBeenCalled.arg == 0)
            
        let textField_4 = UITextField()
        textField_4.text = "9.87"
        view.textFieldDidChange(textField: textField_4)
        XCTAssert(presenter.updateAmountToConvertHasBeenCalled.0 == true)
        XCTAssert(presenter.updateAmountToConvertHasBeenCalled.arg == 9.87)
    }
}
