//
//  CurrencyConverterPresenter.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 02/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import UIKit

class CurrencyConverterPresenter
{
    struct State
    {
        var currentBaseCurrency: CurrencyCode = AppConstants.defaultBaseCurrency
        var currencyRates: [AugmentedCurrencyRateBO] = []
        var amountToConvert: Double = 0
    }
    
    private weak var view: CurrencyConverterViewControllerProtocol?
    private let currencyManager = CurrencyManager(baseCurrency: AppConstants.defaultBaseCurrency)
    private var state: State = State()
    
    var delegates: [Weak<CurrencyRateCell>] = []
    
    init(view: CurrencyConverterViewControllerProtocol?)
    {
        self.view = view
    }
}

extension CurrencyConverterPresenter: CurrencyConverterPresenterProtocol
{
    /** Configure the presenter so that it receives currency rates data */
    func configure()
    {
        currencyManager?.delegate = self
        currencyManager?.startPolling()
    }
    
    /**
     - returns: number of currencyRates in presenter's state
     */
    func numberOfCurrency() -> Int
    {
        return state.currencyRates.count
    }
    
    /**
     Function that fetch currency rate from presenter's state at given index
     
     - parameters:
        - row: index where we want the currency rate
     
     - returns: opt AugmentedCurrencyRateBO corresponding to the currency rate at `row` in presenter's state
     */
    func getCurrencyRate(forRow row: Int) -> AugmentedCurrencyRateBO?
    {
        return state.currencyRates[safe: row]
    }
    
    /**
     Move currency rates in presenter's state to mirror the tableView re-arrangement
     
     - parameters:
        - startIndex: initial index of the currency rate we want to move
        - destinationIndex: destination index of the currency rate we want to move
     */
    func move(startIndex: Int, destinationIndex: Int)
    {
        guard let movedObject = state.currencyRates[safe: startIndex] else { return }
        
        state.currencyRates.remove(at: startIndex)
        state.currencyRates.insert(movedObject, at: destinationIndex)
        
        let newCurrentCurrency = movedObject.currencyInfo.currencyCode
        currencyManager?.baseCurrency = newCurrentCurrency
        
        state.currentBaseCurrency = newCurrentCurrency
        
        updateAmountToConvert(0)
        
        delegates.forEach({
            $0.value?.updateCurrentCurrency(newBaseCurrency: newCurrentCurrency)
        })
    }
    
    /**
     Update state's amountToConvert value
     
     - parameters:
        - newAmount: newAmount `amountToConvert` value
     */
    func updateAmountToConvert(_ newAmount: Double)
    {
        state.amountToConvert = newAmount
        delegates.forEach({
            $0.value?.updateRateAndAmount(from: state.currencyRates,
                                          currentBaseCurrency: state.currentBaseCurrency,
                                          amountToConvert: state.amountToConvert)
        })
    }
    
    /** Getter for presenter `currentBaseCurrency` in its state */
    func getCurrentBaseCurrency() -> CurrencyCode
    {
        return state.currentBaseCurrency
    }
}

extension CurrencyConverterPresenter: CurrencyManagerListener
{
    /**
     Delegate method called every currency manager polling succeeds
     
     - parameters:
        - newCurrencyRates: list of currency rates retrieved by the currency manager
     */
    func currencyRatesDidChange(newCurrencyRates: [AugmentedCurrencyRateBO])
    {
        /** If currency is already displayed, update its value else append the
         *  newCurrency and add it to rows to be inserted in the tableView
         */
        var indexToInsert: [IndexPath] = []
        newCurrencyRates.forEach({ currencyRate in
            if let indexToUpdate = self.state.currencyRates.firstIndex(where: {
                $0.currencyInfo.currencyCode == currencyRate.currencyInfo.currencyCode
            })
            {
                self.state.currencyRates[indexToUpdate] = currencyRate
            }
            else
            {
                self.state.currencyRates.append(currencyRate)
                let indexPath = IndexPath(row: self.state.currencyRates.count - 1, section: 0)
                indexToInsert.append(indexPath)
            }
        })
        self.view?.insertData(at: indexToInsert)

        /** Update delegate cells' rates */
        delegates.forEach({
            $0.value?.updateRateAndAmount(from: newCurrencyRates,
                                          currentBaseCurrency: state.currentBaseCurrency,
                                          amountToConvert: state.amountToConvert)
        })
    }
}
