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
        
        viewController.coordinator = self
        
        viewController.navigationItem.backBarButtonItem = .init()
        viewController.navigationItem.title = "Eventos"
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func eventDetail(model: EventModel, image: UIImage?) {
        
        var controller: EventDetailTableViewController?

        // Exemplo de Injeção de Dependência com Storyboard (Trocar ViewModel para Constante)
        if #available(iOS 13.0, *) {
            
            controller = UIStoryboard(name: "EventDetail", bundle: nil).instantiateInitialViewController { coder in
                return EventDetailTableViewController(coder: coder, model: model)
            }
            
        } else {
            
            controller = UIStoryboard(name: "EventDetail", bundle: nil).instantiateInitialViewController() as? EventDetailTableViewController
            
            controller?.viewModel = .init(model: model)
        }
        
        guard let viewController = controller else {
            return
        }
        
        viewController.image = image
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
