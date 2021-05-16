//
//  UITextView.swift
//  MealSnap
//
//  Created by Asif Shikder on 5/15/21.
//

import UIKit

extension UITextView {
    func addBorder(width: Float = 0.3, radius: Int = 7) {
        self.layer.borderWidth = 0.3
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.gray.cgColor
    }
}
