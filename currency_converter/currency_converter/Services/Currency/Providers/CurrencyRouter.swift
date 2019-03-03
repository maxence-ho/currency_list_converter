//
//  CurrencyRouter.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 24/02/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import Foundation
import Alamofire

/** Routes related to the Currency service */
enum CurrencyRouter: URLRequestConvertible
{
    case getCurrencyRates(baseCurrencyCode: CurrencyCode)
    
    /** HTTP method depending on the route */
    var method: HTTPMethod
    {
        switch self
        {
        case .getCurrencyRates: return .get
        }
    }
    
    /** Base URL depending of the route */
    var path: String
    {
        switch self
        {
        case .getCurrencyRates: return "https://revolut.duckdns.org/latest"
        }
    }
    
    /**
     Gives the request URL (with the correct parameters) for a given route.
     
     - returns: URLRequest for the given route
     */
    func asURLRequest() throws -> URLRequest
    {
        let baseURL = try path.asURL()
        
        var urlRequest = URLRequest(url: baseURL)
        urlRequest.httpMethod = method.rawValue
        
        switch self
        {
        case .getCurrencyRates(let baseCurrencyCode):
            let queryItem = URLQueryItem(name: "base", value: baseCurrencyCode)
            var urlComp = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            urlComp?.queryItems = [queryItem]
            urlRequest.url = urlComp?.url
        }
        
        return urlRequest
    }
}
