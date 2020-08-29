//
//  EventsViewModel.swift
//  EventList
//
//  Created by Filipe Oliveira on 29/08/20.
//  Copyright © 2020 FdSO. All rights reserved.
//

import Foundation

import Alamofire
import RxAlamofire
import RxSwift

final class EventsViewModel: NSObject {

    private(set) var model: BehaviorSubject<[EventModel]> = .init(value: .init())
}

extension EventsViewModel {
    
    func getEvents(completion: ((Bool) -> Void)?) {
        
        removeModel()
        
        let url = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/events"
        
        // exemplo de consumo de API com Alamofire
        AF.request(url).responseDecodable { (response: DataResponse<[EventModel], AFError>) in

            switch response.result {

            case .success(let obj):
                completion?(true)
                self.model.onNext(obj)
                
            case .failure:
                completion?(false)
            }
        }
    }
    
    private func removeModel() {
        
        if let value = try? model.value(), !value.isEmpty {
            model.onNext(.init())
        }
    }
}
