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
    var currencyRate: CurrencyRates?
    var poll: PollAsync<CurrencyRates>?
    var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let requestFactory = RequestFactory(
            getRequest: { return CurrencyServiceProvider.getCurrencyRates(baseCurrency: "EUR") }
        )
        poll = PollAsync<CurrencyRates>(
            requestFactory: requestFactory,
            completion: { newCurrencyRate in
                self.currencyRate = newCurrencyRate
//                print(self.counter)
                self.counter += 1
                if self.counter == 10 { self.poll = nil }
            },
            interval: 1
        )
        
        poll?.start()
    }
}

