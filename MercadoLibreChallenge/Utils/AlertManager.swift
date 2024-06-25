//
//  AlertManager.swift
//  MercadoLibreChallenge
//
//  Created by Jorge Gutierrez on 24/06/24.
//

import UIKit

class AlertManager {
    static let shared = AlertManager()

    private init() {}

    func showAlert(on viewController: UIViewController, title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        viewController.present(alert, animated: true, completion: nil)
    }

    func action(title: String, style: UIAlertAction.Style, handler: (() -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: style) { _ in
            handler?()
        }
    }
}
