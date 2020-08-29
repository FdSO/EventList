//
//  EventModel.swift
//  EventList
//
//  Created by Filipe Oliveira on 29/08/20.
//  Copyright © 2020 FdSO. All rights reserved.
//

import Foundation
import CoreLocation

struct EventModel: Decodable {
    
    struct PeopleModel: Decodable {
        
        let id: String?
        let eventId: String?
        let name: String?
        let picture: String?
    }
    
    struct CouponModel: Decodable {
        
        let id: String?
        let eventId: String?
        let discount: Int?
    }
    
    let id: String?
    private let latitude: CLLocationDegrees
    private let longitude: CLLocationDegrees
    let date: Date?
    let desc: String?
    let imageUrl: URL?
    let price: Decimal?
    let title: String?
    let peoples: [PeopleModel]?
    let coupons: [CouponModel]?

    private enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case date
        case desc = "description"
        case imageUrl = "image"
        case price
        case title
        case coupons = "cupons"
        case peoples = "people"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try? values.decode(String.self, forKey: .id)
        latitude = try values.decodeIfPresent(CLLocationDegrees.self, forKey: .latitude) ?? .zero
        longitude = try values.decodeIfPresent(CLLocationDegrees.self, forKey: .longitude) ?? .zero
        
        if let value = try? values.decode(TimeInterval.self, forKey: .date) {
            date = .init(timeIntervalSince1970: value / 1000)
        } else {
            date = try? values.decode(Date.self, forKey: .date)
        }
        
        desc = try? values.decode(String.self, forKey: .desc)
        imageUrl = try? values.decode(URL.self, forKey: .imageUrl)
        price = try? values.decode(Decimal.self, forKey: .price)
        title = try? values.decode(String.self, forKey: .title)
        peoples = try? values.decode([PeopleModel].self, forKey: .peoples)
        coupons = try? values.decode([CouponModel].self, forKey: .coupons)
    }
}
