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
    
    func isValidEmail() -> Bool {
            
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    
    func asImage(withAttributes attributes: [NSAttributedString.Key: Any]? = nil, size: CGSize? = nil) -> UIImage? {
        
        let size = size ?? (self as NSString).size(withAttributes: attributes)
        
        return UIGraphicsImageRenderer(size: size).image { _ in
            (self as NSString).draw(in: .init(origin: .zero, size: size), withAttributes: attributes)
        }
    }
}

extension Date {
    
    func asString(timeStyle: DateFormatter.Style = .full, dateStyle: DateFormatter.Style = .full, locale: Locale = .current) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = timeStyle
        dateFormatter.dateStyle = dateStyle
        dateFormatter.locale = locale
        
        return dateFormatter.string(from: self)
    }
}

import CoreLocation

extension CLLocation {
    
    func getPlaceMark(completion: @escaping (Result<CLPlacemark, NSError>) -> Void) {
        
        CLGeocoder().reverseGeocodeLocation(self) { (placeMarks, error) in
            
            if let e = error as NSError? {
                completion(.failure(e))
            } else if let placeMark = placeMarks?.first {
                completion(.success(placeMark))
            } else {
                completion(.failure(.init(domain: "CLGeocoder", code: .zero, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
            }
        }
    }
}
