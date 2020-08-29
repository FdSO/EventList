//
//  EventDetailTableViewController.swift
//  EventList
//
//  Created by Filipe Oliveira on 29/08/20.
//  Copyright © 2020 FdSO. All rights reserved.
//

import UIKit

import MapKit

// exemplo de controller sem RxSwift

final class EventDetailTableViewController: UITableViewController {
    
    @IBOutlet private weak var mapView: MKMapView!
    
    @IBOutlet private weak var titleView: UIImageView!
    
    @IBAction private func refreshControllWasTapped() {
        
        viewModel?.model.getPlaceMark(completion: { (result: Result<CLPlacemark, NSError>) in

            self.refreshControl?.endRefreshing()
            
            switch result {
                
            case .success(let obj):
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                let annotation = MKPointAnnotation()
                annotation.title = (obj.name ?? "") + " - " + (obj.subLocality ?? "")
                annotation.subtitle = obj.locality
                annotation.coordinate = obj.location?.coordinate ?? .init()
                
                self.mapView.setCenter(obj.location?.coordinate ?? .init(), animated: true)
                
                self.mapView.addAnnotation(annotation)

            case .failure(_): break
            }
        })
    }
    
    @IBAction private func checkinWasTapped() {
        
        presentAlertForm(title: "Check-in", message: "Informe os dados do Interessado.", placeholderFirst: "Nome", placeholderSecond: "Email", image: image, eventId: viewModel?.model.id) { result in
            
            if let people = result {
                self.viewModel?.postChekin(parameter: people) { (isSuccess) in
                    
                    self.presentAlert(title: nil, message: isSuccess ? "Check-in com Sucesso!" : "No foi possivel faze o Check-in", preferredStyle: .alert, completion: nil)
                }
            }
        }
    }
    
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
        
        initState()
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
            presentAlert(title: "Data do Evento", message: viewModel?.model.date?.asString(timeStyle: .short, dateStyle: .full, locale: AppProperties.locale) ?? "A definir", preferredStyle: .actionSheet)
        }
    }
}

extension EventDetailTableViewController {
    
    private func initState() {
        refreshControl?.beginRefreshing()
        refreshControl?.sendActions(for: .valueChanged)
        
        titleView.image = image?.af.imageRoundedIntoCircle()
        
        navigationItem.titleView = titleView
    }
    
    // validação de campos interno de um alertController - habilita ou não o botão de confirmar
    @objc private func alertControllerFormTextEditing(sender: UITextField) {
        var responder: UIResponder? = sender
        
        while !(responder is UIAlertController) {
            responder = responder?.next
        }
        
        let alertController = responder as? UIAlertController
        
        if (alertController?.actions.count ?? 0) > 1, (alertController?.textFields?.count ?? 0) > 1 {
            
            let hasEmail = ((alertController?.textFields?[1])?.text ?? .init()).isValidEmail()
            
            let hasEmpty = (alertController?.textFields?.allSatisfy { !($0.text ?? .init()).isEmpty }) ?? false
            
            alertController?.actions[1].isEnabled = hasEmpty && hasEmail
        }
    }
    
    private func presentAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style, completion: (() -> Void)? = nil) {
        
        let alertController: UIAlertController = .init(title: title, message: message, preferredStyle: preferredStyle)
        
        let okAction: UIAlertAction = .init(title: "OK", style: .default) { (_) in
            completion?()
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    // formulário utilizando API privada Apple
    private func presentAlertForm(title: String?, message: String?, placeholderFirst: String?, placeholderSecond: String?, image: UIImage?, eventId: String?, completion: @escaping (InterestedModel?) -> Void) {
        
        let alertController: UIAlertController = .init(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = placeholderFirst
            textField.addTarget(self, action: #selector(self.alertControllerFormTextEditing(sender:)), for: .editingChanged)
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = placeholderSecond
            textField.addTarget(self, action: #selector(self.alertControllerFormTextEditing(sender:)), for: .editingChanged)
        }
        
        let okAction: UIAlertAction = .init(title: "Confirmar", style: .default) { (action) in
            
            guard let eventId = eventId else {
                return
            }
            
            guard let name = alertController.textFields?[0].text, !name.isEmpty else {
                return
            }

            guard let email = alertController.textFields?[1].text, email.isValidEmail() else {
                return
            }

            let people = InterestedModel(eventId: eventId, name: name, email: email)
            
            completion(people)
        }
        
        okAction.isEnabled = false
        
        let cancelAction: UIAlertAction = .init(title: "Cancelar", style: .default) { (_) in
            completion(nil)
        }
        
        let imageAction: UIAlertAction = .init()
        
        let alertViewWidth: CGFloat = alertController.view.subviews.first?.constraints.first(where: { $0.firstAttribute == .width && $0.constant > 0 })?.constant ?? 0
        
        let alertInternalPadding: CGFloat = alertViewWidth != 0 ? 25 : 0
        
        let imageWidth: CGFloat = (image?.size.width ?? 0) + alertInternalPadding
        
        let inset = abs(alertViewWidth - imageWidth) / 2
        imageAction.setValue(image?.withAlignmentRectInsets(.init(top: 0, left: -inset, bottom: 0, right: 0)), forKey: "image")
        
        alertController.addAction(imageAction)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        alertController.preferredAction = okAction
        
        present(alertController, animated: true)
    }
}
