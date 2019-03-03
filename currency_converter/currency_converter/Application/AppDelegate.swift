//
//  AppDelegate.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 22/02/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        displayInitialViewController()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}

extension AppDelegate
{
    private func displayInitialViewController()
    {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: AppConstants.Storyboards.Main.rawValue,
                                                         bundle: nil)
        let currencyConverterViewController = mainStoryboard.instantiateViewController(withIdentifier: CurrencyConverterViewController.identifier) as! CurrencyConverterViewController
        let currencyConverterPresenter = CurrencyConverterPresenter(view: currencyConverterViewController)
        currencyConverterViewController.presenter = currencyConverterPresenter
        
        let navViewController = UINavigationController.init(rootViewController: currencyConverterViewController)
        navViewController.navigationBar.barStyle = .blackTranslucent
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navViewController
        window?.makeKeyAndVisible()
    }
}
