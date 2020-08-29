//
//  EventListUITests.swift
//  EventListUITests
//
//  Created by Filipe Oliveira on 29/08/20.
//  Copyright © 2020 FdSO. All rights reserved.
//

import XCTest

class EventListUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // exemplo de teste para salvar um evento na galeria (caso tenha mudança na UI, precisa ser revisto)
    func testShareEvent() throws {
        
        let app = XCUIApplication()
        app.launch()
    
//        print(app.debugDescription)
        
        // índice para célula
        let cell = app.tables.cells.element(boundBy: .random(in: 0...2))
        
        // verifica se a célula existe e se é clickavel - inicialização lenta (lazy)
        if cell.isHittable {
            
            cell.tap()
            
            app.buttons.element(boundBy: 3).tap()
            
            app.buttons.element(boundBy: 4).tap()
            
            app.tables.buttons.element(boundBy: 0).tap()
            
            app.navigationBars.buttons.element(boundBy: 1).tap()
            
            app.collectionViews.cells.element(boundBy: 1).tap()
            
            addUIInterruptionMonitor(withDescription: "Share") { (alert) -> Bool in
                let alertButton = alert.buttons.element(boundBy: 1)
                
                if alertButton.exists {
                    alertButton.tap()
                    return true
                }
                
                return false
            }
            
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
