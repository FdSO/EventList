//
//  EventsTableViewController.swift
//  EventList
//
//  Created by Filipe Oliveira on 29/08/20.
//  Copyright © 2020 FdSO. All rights reserved.
//

import UIKit

import AlamofireImage
import RxSwift
import RxCocoa

final class EventsTableViewController: UITableViewController {

    @IBAction private func refreshControllWasTapped() {

        viewModel.getEvents { isSuccess in
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    private let viewModel: EventsViewModel = .init()
    
    private let bag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initState()
        
        viewModel.model
            .bind(to: tableView.rx.items(cellIdentifier: "DEFAULT_CELL", cellType: UITableViewCell.self)) { _, model, cell in
           
                cell.textLabel?.text = model.title

                cell.detailTextLabel?.text = model.price?.asCurrency(locale: AppProperties.locale) ?? "-"

                if let url = model.imageUrl {

                    let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: .init(width: 80, height: 80), radius: 20, divideRadiusByImageScale: true)

                    cell.imageView?.af.setImage(withURL: url, filter: filter, imageTransition: .flipFromLeft(0.3), runImageTransitionIfCached: false, completion: { (response) in

                        cell.setNeedsLayout()
                        cell.layoutIfNeeded()
                    })
                } else {
                    cell.setNeedsLayout()
                    cell.layoutIfNeeded()
                }
            }
            .disposed(by: bag)
    }
}

extension EventsTableViewController {
    
    private func initState() {
        refreshControl?.beginRefreshing()
        refreshControl?.sendActions(for: .valueChanged)
        
        // construção de tela com storyboard, necessita desabilitar
        tableView.dataSource = nil
        tableView.delegate = nil
    }
}
