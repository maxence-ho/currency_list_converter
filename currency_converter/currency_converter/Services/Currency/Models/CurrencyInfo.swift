//
//  CurrencyListInfo.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 01/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

struct CurrencyInfo: Decodable
{
    let code: String
    let name: String
    let symbol: String
}

/** Wrapper structure returned by mocked service. And containing CurrencInfo list */
struct CurrencyListInfo: Decodable
{
    struct Response: Decodable
    {
        let status: String
        let currencies: [CurrencyInfo]
    }
    let response: Response
}

