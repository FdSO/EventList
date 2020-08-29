//
//  Extensions.swift
//  EventList
//
//  Created by Filipe Oliveira on 29/08/20.
//  Copyright © 2020 FdSO. All rights reserved.
//

import Foundation

extension Decimal {
    
    func asCurrency(locale: Locale = .current) -> String? {
        
        let numberFormatter = NumberFormatter()
        
        numberFormatter.locale = locale
        numberFormatter.numberStyle = .currency
        
        return numberFormatter.string(from: self as NSNumber)
    }
}
