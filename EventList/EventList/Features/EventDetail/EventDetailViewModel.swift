//
//  EventDetailViewModel.swift
//  EventList
//
//  Created by Filipe Oliveira on 29/08/20.
//  Copyright © 2020 FdSO. All rights reserved.
//

import Foundation

import Alamofire
import RxAlamofire
import RxSwift

final class EventDetailViewModel: NSObject {

    private(set) var model: EventModel
    
    private let bag = DisposeBag()
    
    init(model: EventModel) {
        self.model = model
    }
}

extension EventDetailViewModel {
    
    func postChekin(parameter: InterestedModel, completion: @escaping (Bool) -> Void) {

        let url = "http://5b840ba5db24a100142dcd8c.mockapi.io/api/checkin"
        
        // algumas validações necessária, qualquer parametro funciona
        // exemplo de consumo de API com RxAlamofire
        request(.post, url, parameters: parameter.dictionary, encoding: JSONEncoding.default, headers: nil, interceptor: nil)
            .validate(statusCode: 201...201)
            .validate(contentType: ["application/json"])
            .json()
            .map({ (json) -> String in
                guard let dictionary = json as? Parameters,
                    let code = dictionary["code"] as? String else {
                        return .init()
                }

                return code
            })
            .subscribe(onNext: { (code) in
                completion(code == "200")
            }, onError: { (error) in
                completion(false)
            }).disposed(by: bag)
    }
}
