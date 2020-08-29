//
//  AppCoordinator.swift
//  EventList
//
//  Created by Filipe Oliveira on 29/08/20.
//  Copyright © 2020 FdSO. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = .init()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        events()
    }
    
    private func events() {
        guard let viewController = UIStoryboard(name: "Events", bundle: nil).instantiateInitialViewController() as? EventsTableViewController else {
            return
        }
        
        viewController.navigationItem.backBarButtonItem = .init()
        viewController.navigationItem.title = "Eventos"
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
