//
//  SettingsViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 3/23/21.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var hideDetailSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideDetailSwitch.setOn(UserPreference.HideImageDetail(), animated: true)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onChangeHideImagePreference(_ sender: UISwitch) {
        UserPreference.HideImageDetail(set: sender.isOn)
    }
    
    
    @IBAction func handleLogout() {
        AuthService.logout(){_ in }
    }
}
