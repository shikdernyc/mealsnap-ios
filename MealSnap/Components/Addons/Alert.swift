//
//  Alert.swift
//  MealSnap
//
//  Created by Asif Shikder on 3/22/21.
//
import UIKit

struct AlertComponent {
    static func showAlert(on vc: UIViewController, title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    static func showError(on vc: UIViewController, message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
}
