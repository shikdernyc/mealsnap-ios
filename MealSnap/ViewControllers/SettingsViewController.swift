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
        AuthManager.logout(){_ in }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
