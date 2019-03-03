//
//  Weak.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 03/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

/** Wrapper that contains a weak reference of an object */
class Weak<T: AnyObject>
{
    weak var value : T?
    init (value: T)
    {
        self.value = value
    }
}
