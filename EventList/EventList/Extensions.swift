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

extension Encodable {
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }

        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}

import UIKit

extension String {
    
    func asImage(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage? {
        
        let size = size ?? (self as NSString).size(withAttributes: attributes)
        
        return UIGraphicsImageRenderer(size: size).image { _ in
            (self as NSString).draw(in: .init(origin: .zero, size: size), withAttributes: attributes)
        }
    }
}
