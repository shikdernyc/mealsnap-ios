//
//  AppUIButton.swift
//  MealSnap
//
//  Created by Asif Shikder on 5/16/21.
//

import UIKit

@IBDesignable class AppUIButton: UIButton {
    @IBInspectable var rounded : Bool = false {
        didSet{
            layer.cornerRadius = 6
        }
    }

}
