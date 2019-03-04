//
//  CurrencyRateCell.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 02/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import UIKit

class CurrencyRateCell: UITableViewCell
{
    @IBOutlet weak var currencyFlagImageView: UIImageView!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyFullNameLabel: UILabel!
    @IBOutlet weak var currencyAmountTextField: UITextField!

    /** Code of the currency that the cell represent */
    var currencyCode: CurrencyCode? = nil
}

extension CurrencyRateCell
{
    override func awakeFromNib()
    {
        currencyFlagImageView.rounded()
    }
}

extension CurrencyRateCell
{
    /**
     Configure the cell - Called when cell is dequeued
     
     - parameters:
        - currencyRate: currency rate info for the cell
        - presenter: presenter associated to the viewController containing the cell
        - controller: viewController containing the cell
     */
    func configure(currencyRate: AugmentedCurrencyRateBO,
                   presenter: CurrencyConverterPresenter,
                   controller: CurrencyConverterViewController)
    {
        /** Update cell currency code */
        currencyCode = currencyRate.currencyInfo.currencyCode
        /** Update cell static data representation */
        currencyCodeLabel.text = currencyRate.currencyInfo.currencyCode
        currencyFullNameLabel.text = currencyRate.currencyInfo.currencyFullname
        currencyFlagImageView.image = currencyRate.currencyInfo.flagImage
        
        /** Register the cell as delegate to the presenter.
         *  Only register to presenter if it's not already registered
         *  This will allow the cell to be notified when the current currency
         *  changes or when the rate or amountToConvert changes
         */
        guard
            !presenter.delegates.contains(where: {
                $0.value == self
            })
        else { return }
        presenter.delegates.append(Weak(value: self))
        
        /** Add targets for the textField actions on the viewController */
        currencyAmountTextField.addTarget(controller,
                                          action: #selector(CurrencyConverterViewController.textFieldDidChange(textField:)),
                                          for: .editingChanged)
    }
}

/** Implementation of CurrencyConverterPresenter delegates methods */
extension CurrencyRateCell
{
    /**
     Upon receiving a newBaseCurrency
     If the cell is concerned by the change of base currency -> configure
     the cell as input cell. Else -> configure the cell as display cell
     
     - parameters:
        - newBaseCurrency: CurrencyCode of the new base currency
     */
    func updateCurrentCurrency(newBaseCurrency: CurrencyCode)
    {
        guard newBaseCurrency == currencyCode else
        {
            configureAsDisplayCell()
            return
        }
        
        configureAsInputCell()
    }
    
    /**
     Upon receiving a new rate and amount -> Update textField
     
     - parameters:
        - newRates: updated rate info
        - currentBaseCurrency: currency code of the base currency
        - amountToConvert: value of the amount of base currency
     */
    func updateRateAndAmount(from newRates: [AugmentedCurrencyRateBO],
                             currentBaseCurrency: CurrencyCode,
                             amountToConvert: Double)
    {
        /** Check that cell does not correspond to base currency and that we can
         *  find it in `newRates`
         */
        guard
            let newRateInfo = newRates.first(where: { [weak self] in
                guard let self = self else { return false }
                return $0.currencyInfo.currencyCode == self.currencyCode
            }),
            currentBaseCurrency != currencyCode
        else { return }
        /** Update converted amount display */
        updateCurrencyAmountTextField(amountToConvert: amountToConvert,
                                      conversionRate: newRateInfo.conversionRate)
    }
}

/** Helper methods */
extension CurrencyRateCell
{
    private func configureAsInputCell()
    {
        contentView.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        currencyAmountTextField.isUserInteractionEnabled = true
        currencyAmountTextField.text = ""
        currencyAmountTextField.becomeFirstResponder()
    }
    
    private func configureAsDisplayCell()
    {
        currencyAmountTextField.isUserInteractionEnabled = false
        currencyAmountTextField.resignFirstResponder()
        contentView.backgroundColor = .clear
    }
    
    private func updateCurrencyAmountTextField(amountToConvert: Double, conversionRate: Double)
    {
        let fmt = NumberFormatter()
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.maximumFractionDigits = 2
        fmt.minimumFractionDigits = 0
        fmt.minimumIntegerDigits = 1
        
        let number = NSNumber(value: amountToConvert * conversionRate)
        currencyAmountTextField.text = fmt.string(from: number)
    }
}

extension CurrencyRateCell
{
    static var height: CGFloat = 80.0
}
