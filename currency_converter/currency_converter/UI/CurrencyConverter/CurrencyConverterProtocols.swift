//
//  CurrencyConverterProtocols.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 02/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import Foundation

protocol CurrencyConverterViewControllerProtocol: class
{
    /**
     Add rows to tableView at given indexPath
     
     - parameters:
        - indexPathArray: list of IndexPath where a cell should be added
     */
    func insertData(at indexPathArray: [IndexPath])
}

protocol CurrencyConverterPresenterProtocol: class
{
    /** Configure the presenter so that it receives currency rates data */
    func configure()
    
    /**
     - returns: number of currencyRates in presenter's state
     */
    func numberOfCurrency() -> Int
    
    /**
     Function that fetch currency rate from presenter's state at given index
     
     - parameters:
     - row: index where we want the currency rate
     
     - returns: opt AugmentedCurrencyRateBO corresponding to the currency rate at `row` in presenter's state
     */
    func getCurrencyRate(forRow row: Int) -> AugmentedCurrencyRateBO?
    
    /**
     Move currency rates in presenter's state to mirror the tableView re-arrangement
     
     - parameters:
     - startIndex: initial index of the currency rate we want to move
     - destinationIndex: destination index of the currency rate we want to move
     */
    func move(startIndex: Int, destinationIndex: Int)
    
    /**
     Update state's amountToConvert value
     
     - parameters:
     - newAmount: newAmount `amountToConvert` value
     */
    func updateAmountToConvert(_ newAmount: Double)
    
    /** Getter for presenter `currentBaseCurrency` in its state */
    func getCurrentBaseCurrency() -> CurrencyCode
}

