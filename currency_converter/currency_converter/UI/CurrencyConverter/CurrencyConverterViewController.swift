//
//  CurrencyConverterViewController.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 02/03/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import UIKit

// TODO: Use UITableViewController subclass to get automatic scrolling on keyboard apparition
class CurrencyConverterViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: CurrencyConverterPresenterProtocol? = nil
}

/** Lifecycle methods */
extension CurrencyConverterViewController
{
    override func viewDidLoad()
    {
        presenter?.configure()
        
        title = AppConstants.mainScreenTitle
        
        /** TableView configuration */
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: CurrencyRateCell.identifier, bundle: nil),
            forCellReuseIdentifier: CurrencyRateCell.identifier
        )
        
        /** Register to keyboard system notifications to handle automatic scroll
         *  on keyboard apparition
         */
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
}

/** TableView delegate methods */
extension CurrencyConverterViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return presenter?.numberOfCurrency() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyRateCell.identifier,
                                                 for: indexPath) as! CurrencyRateCell
        /** Configure the cell */
        DispatchQueue.main.async {
            if
                let currencyRate = self.presenter?.getCurrencyRate(forRow: indexPath.row),
                let presenter = self.presenter as? CurrencyConverterPresenter
            {
                cell.configure(currencyRate: currencyRate,
                               presenter: presenter,
                               controller: self)
                cell.updateCurrentCurrency(newBaseCurrency: presenter.getCurrentBaseCurrency())
            }
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard indexPath.row != 0 else { return }
        
        /** Update data source - should be done first -> reset all amounts to 0
         *  (makes a smoothier transition)
         */
        self.presenter?.move(startIndex: indexPath.row, destinationIndex: 0)
        
        /** Move selected cell to top */
        self.tableView.beginUpdates()
        self.tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        self.tableView.endUpdates()
        
        /** Scroll to top */
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CurrencyRateCell.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CurrencyRateCell.height
    }
}

extension CurrencyConverterViewController: CurrencyConverterViewControllerProtocol
{
    /**
     Add rows to tableView at given indexPath
     
     - parameters:
        - indexPathArray: list of IndexPath where a cell should be added
     */
    func insertData(at indexPathArray: [IndexPath])
    {
        guard !indexPathArray.isEmpty else { return }
    
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: indexPathArray, with: .none)
        self.tableView.endUpdates()
    }
}

extension CurrencyConverterViewController
{
    /**
     Callback method called when one of the cell's texfield has its text changed
     
     - parameters:
        - textField: input textField
     */
    @objc func textFieldDidChange(textField: UITextField)
    {
        guard let text = textField.text else { return }
        guard !text.isEmpty else {
            presenter?.updateAmountToConvert(0)
            return
        }
        
        if let amount = NumberFormatter().number(from: text)?.doubleValue
        {
            presenter?.updateAmountToConvert(amount)
        }
    }
}

/** Callback for keyboard show/hide */
extension CurrencyConverterViewController
{
    @objc func keyboardWillShow(_ notification:Notification)
    {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification)
    {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
