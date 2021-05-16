//
//  LoginViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 3/22/21.
//

import UIKit

struct TempUserInfo {
    static let username = "defaultuser"
    static let password = "P@5sword"
}

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = TempUserInfo.username
        passwordTextField.text = TempUserInfo.password
        print("Login Page Loaded")
        // Do any additional setup after loading the view.
    }
    
    func showError(message: String) -> Void {
        DispatchQueue.main.async {
            self.errorMessageLabel.text = message
            self.errorMessageLabel.isHidden = false
        }
    }
    
    func closeErrorMessage() -> Void {
        DispatchQueue.main.async {
            if self.errorMessageLabel.isHidden == false {
                self.errorMessageLabel.isHidden = true
            }
        }
    }
    
    @IBAction func handleLogin() {
        self.closeErrorMessage()
        guard let email = emailTextField.text else {
            self.showError(message: "Email is required")
            return
        }
        guard let password = passwordTextField.text else {
            self.showError(message: "Password is required")
            return
        }
        AuthService.login(username: email, password: password) { result in
            switch result{
            case.failure(let error):
                // TODO: Set Error Message
                self.showError(message: error.errorDescription)
                return
            case .success:
                DispatchQueue.main.async {
                    guard let rootAuthController = self.storyboard?.instantiateViewController(identifier: StoryboardId.AuthTabNavigationController.rawValue) else {
                        return
                    }
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(controller: rootAuthController)
                }
            }
        };
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
