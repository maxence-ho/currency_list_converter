//
//  UIView+manipulation.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 02/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import UIKit

extension UIView
{
    /** Round UIView's corner (makes a circle if view is a square) */
    public func rounded()
    {
        let diameter = frame.width < frame.height ? frame.width : frame.height
        layer.cornerRadius = diameter / 2
        layer.masksToBounds = true
    }
}
