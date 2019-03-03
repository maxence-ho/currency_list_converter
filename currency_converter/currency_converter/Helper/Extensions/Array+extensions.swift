//
//  Array+extensions.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 03/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

extension Array {
    /** Safe subscript -> return nil if out of range */
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
