//
//  RequestFactory.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 24/02/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import Promises

/** Struct able to generate requests on demand (as Promises) */
struct RequestFactory<T: Codable>
{
    /** Inputed closure to generate requests */
    var getRequest: (() -> Promise<T>)!
}
