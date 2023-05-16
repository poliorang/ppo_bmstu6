//
//  AlertManager.swift
//  rfpr
//
//  Created by poliorang on 01.05.2023.
//

import Foundation
import UIKit

final class AlertManager {
    static let shared = AlertManager()
    
    init() { }
    
    func showAlert(presentTo controller: UIViewController, title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}
