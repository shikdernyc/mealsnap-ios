//
//  LoginViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 3/22/21.
//

import UIKit

class LoginViewController: UIViewController {
    static let StoryboardId = "login_vc"
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login Page Loaded")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleLogin() {
//        guard let rootAuthController = storyboard?.instantiateViewController(identifier: "root_tab_vc") else {
//            return
//        }
//        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(controller: rootAuthController)
        AuthManager.login(email: "", password: "")
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
