//
//  ViewController.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 22/02/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import UIKit
import Promises

class ViewController: UIViewController
{
    @IBOutlet weak var flagImageView: UIImageView!
    
    var currencyManager: CurrencyManager?
    var counter = 0
    var currencyRates: [AugmentedCurrencyRateBO] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.currencyManager = CurrencyManager(baseCurrency: "EUR")
        self.currencyManager?.delegate = self
        self.currencyManager?.startPolling()
    }
    
    @IBAction func changeBaseCurrency(_ sender: Any)
    {
        self.currencyManager?.baseCurrency = self.currencyManager?.baseCurrency == "EUR" ? "JPY" : "EUR"
    }
}

extension ViewController: CurrencyManagerListener
{
    func currencyRatesDidChange(newCurrencyRates: [AugmentedCurrencyRateBO])
    {
        self.currencyRates = newCurrencyRates
        let usdRateInfo = newCurrencyRates.first(where: { currencyRateBO -> Bool in
            return currencyRateBO.currencyInfo.currencyCode == "USD"
        })
        print("\(usdRateInfo!.currencyInfo.currencyCode): \(usdRateInfo!.conversionRate)\(usdRateInfo!.currencyInfo.symbol) -> 1 \(currencyManager!.baseCurrency)")
    }
}
