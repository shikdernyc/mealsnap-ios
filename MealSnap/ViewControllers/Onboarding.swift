//
//  ViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 3/21/21.
//

import UIKit
import Amplify

class OnboardingViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(named: "Background.Onboarding")
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "Background.Onboarding")
        // Do any additional setup after loading the view.
    }
    
}
