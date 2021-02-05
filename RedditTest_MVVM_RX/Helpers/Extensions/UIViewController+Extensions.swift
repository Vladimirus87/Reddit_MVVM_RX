//
//  UIViewController+Extensions.swift
//  TestWorkRaketa
//
//  Created by Vladimirus on 28.10.2020.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(msg: String, delay: TimeInterval = 1.2) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                alert.dismiss(animated: true)
            }
        })
    }
    
    /*
    func errorHandler(_ error: RedditClientError) {
        switch error {
        case .noConnection(let description):
            self.showErrorAlert(msg: description ?? "Server error")
        case .parsingError:
            self.showErrorAlert(msg: "Parsing error")
        }
    }
    */
    
}
