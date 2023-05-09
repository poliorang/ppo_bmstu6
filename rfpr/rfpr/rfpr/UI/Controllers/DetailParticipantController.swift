//
//  DetailParticipantController.swift
//  rfpr
//
//  Created by poliorang on 08.05.2023.
//

import UIKit

class DetailParticipantViewController: UIViewController {
    var services: ServicesManager! = nil
    let alertManager = AlertManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupServices()
    }
    
    private func setupServices() {
        do {
            try services = ServicesManager()
        } catch {
            alertManager.showAlert(presentTo: self,
                                   title: "Внимание",
                                   message: "Не удалось получить доступ к базе данных")
        }
    }

}
