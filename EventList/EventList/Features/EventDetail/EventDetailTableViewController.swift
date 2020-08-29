//
//  EventDetailTableViewController.swift
//  EventList
//
//  Created by Filipe Oliveira on 29/08/20.
//  Copyright © 2020 FdSO. All rights reserved.
//

import UIKit

// exemplo de controller sem RxSwift

final class EventDetailTableViewController: UITableViewController {
    
    @IBOutlet private weak var titleView: UIImageView!
    
    var image: UIImage?
    
    // Limitação de Injeção de Dependência com Storyboard <iOS13 variável opcional precisa ser preenchida após inicialização da viewController
    var viewModel: EventDetailViewModel?
    
    
    // Injeção de Dependência com Storyboard iOS13+
    
//    let viewModel: EventDetailViewModel
//
    init?(coder: NSCoder, model: EventModel) {
        viewModel = .init(model: model)
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // Injeção de Dependência com ViewCode

//
//    init(style: UITableView.Style, model: EventModel) {
//        viewModel = .init(model: model)
//        super.init(style: style)
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.image = image?.af.imageRoundedIntoCircle()
        
        navigationItem.titleView = titleView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            
        case 0: return 3
            
        case 1: return viewModel?.model.peoples?.count ?? .zero
            
        case 2: return viewModel?.model.coupons?.count ?? .zero
            
        default: return .zero
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            switch indexPath.row {
                
            case 0:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "SECTION0_CELL0", for: indexPath)
                
                cell.accessoryType = .detailButton
                
                cell.textLabel?.text = "Evento"
                
                cell.detailTextLabel?.text = viewModel?.model.title?.capitalized
                cell.detailTextLabel?.numberOfLines = 0
                
                return cell
                
            case 1:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "SECTION0_CELL0", for: indexPath)
                
                cell.accessoryType = .none
                
                cell.textLabel?.text = "Preço"
                
                cell.detailTextLabel?.text = viewModel?.model.price?.asCurrency(locale: AppProperties.locale)
                cell.detailTextLabel?.numberOfLines = 1
                
                return cell
                
            case 2:
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SECTION0_CELL1", for: indexPath) as? TextViewTableViewCell else {
                    return .init()
                }
                
                cell.textView.text = viewModel?.model.desc
                
                return cell
                
            default:
                return .init()
            }
            
        case 1:
            
            guard let people = viewModel?.model.peoples?[indexPath.row] else {
                return .init()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SECTION1_CELL0", for: indexPath)
            
            cell.imageView?.image = people.picture?.uppercased().asImage(withAttributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            
            cell.textLabel?.text = people.name?.capitalized
            
            return cell
            
        case 2:
        
            guard let coupon = viewModel?.model.coupons?[indexPath.row] else {
                return .init()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SECTION2_CELL0", for: indexPath)
            
            cell.textLabel?.text = nil
            
            cell.detailTextLabel?.text = "\(coupon.discount ?? 0)%"
            
            return cell

        default: return .init()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
            
        case 0: return "Informações"
            
        case 1: return "Pessoas"
            
        case 2: return "Cupons de Desconto"
            
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        switch section {
            
        case 1: return "Quantidade de Pessoas: \(viewModel?.model.peoples?.count ?? .zero)"
        
        case 2: return "Quantidade de Cupons: \(viewModel?.model.coupons?.count ?? .zero)"
            
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        if indexPath == .init(row: 0, section: 0) {
            presentActionSheet(title: "Data do Evento", message: viewModel?.model.date?.asString(timeStyle: .short, dateStyle: .full, locale: AppProperties.locale) ?? "A definir")
        }
    }
}

extension EventDetailTableViewController {
    
    private func presentActionSheet(title: String?, message: String?, completion: (() -> Void)? = nil) {
        
        let alertController: UIAlertController = .init(title: title, message: message, preferredStyle: .actionSheet)
        
        let okAction: UIAlertAction = .init(title: "OK", style: .default) { (_) in
            completion?()
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
}
