//
//  EventListTests.swift
//  EventListTests
//
//  Created by Filipe Oliveira on 29/08/20.
//  Copyright © 2020 FdSO. All rights reserved.
//

import Alamofire

import XCTest
@testable import EventList

class EventListTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // teste de um check-in
    func testCheckin() {
        
        // exemplo de um json de evento sendo convertido para um modelo
        guard let jsonData = """
                        {"people":[{"id":"1","eventId":"1","name":"name 1","picture":"picture 1"}],"date":1534784400000,"description":"O Patas Dadas estará na Redenção, nesse domingo, com cães para adoção e produtos à venda!\\n\\nNa ocasião, teremos bottons, bloquinhos e camisetas!\\n\\nTraga seu Pet, os amigos e o chima, e venha aproveitar esse dia de sol com a gente e com alguns de nossos peludinhos - que estarão prontinhos para ganhar o ♥ de um humano bem legal pra chamar de seu. \\n\\nAceitaremos todos os tipos de doação:\\n- guias e coleiras em bom estado\\n- ração (as que mais precisamos no momento são sênior e filhote)\\n- roupinhas \\n- cobertas \\n- remédios dentro do prazo de validade","image":"http://lproweb.procempa.com.br/pmpa/prefpoa/seda_news/usu_img/Papel%20de%20Parede.png","longitude":-51.2146267,"latitude":-30.0392981,"price":29.99,"title":"Feira de adoção de animais na Redenção","id":"1","cupons":[{"id":"1","eventId":"1","discount":62}]}
                        """.data(using: .utf8),
              let model = try? JSONDecoder().decode(EventModel.self, from: jsonData) else {
            return
        }
        
        let expectation = XCTestExpectation(description: "CHECK-IN")
        
        let viewModel = EventDetailViewModel(model: model)
        
        viewModel.postChekin(parameter: .init(eventId: "1", name: "Teste", email: "teste@teste.com"), completion: { (isSuccess) in
            
            XCTAssertTrue(isSuccess, "Indisponível")
            
            expectation.fulfill()
        })
        
        // tempo suficiente para as requição de acordo com timeout do Alamofire
        wait(for: [expectation], timeout: AF.sessionConfiguration.timeoutIntervalForRequest)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
