//
//  AppTextField.swift
//  MealSnap
//
//  Created by Asif Shikder on 5/16/21.
//

import UIKit

@IBDesignable class AppUITextField: UITextField {

    @IBInspectable var borderWidth : CGFloat = 0.2 {
        didSet {
            self.layer.borderWidth = borderWidth
            self.layer.cornerRadius = 7
            self.layer.masksToBounds = true
            self.layer.borderColor = UIColor(named: "Component.Border")?.cgColor
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
