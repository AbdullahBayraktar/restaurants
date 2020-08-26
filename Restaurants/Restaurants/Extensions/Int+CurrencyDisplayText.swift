//
//  Int+CurrencyDisplayText.swift
//  Restaurants
//
//  Created by Abdullah Bayraktar on 26.08.20.
//  Copyright © 2020 Abdullah Bayraktar. All rights reserved.
//

import Foundation

extension Int {
    func currencyDisplayText() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        numberFormatter.currencyCode = "EUR"
        numberFormatter.minimumFractionDigits = 0
        
        let number = NSNumber(value:  Double(self) / 100)
        
        return numberFormatter.string(from: number) ?? ""
    }
}
