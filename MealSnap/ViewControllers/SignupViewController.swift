//
//  SignupViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 3/22/21.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showError(message: String) -> Void {
        DispatchQueue.main.async {
            print("Showing error message")
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
    
    @IBAction func handlePressSignup() {
        print("Handling signup")
        self.closeErrorMessage()
        guard usernameTextField.text?.count != 0 else {
            showError(message: "Username is required")
            return
        }
        guard emailTextField.text?.count != 0 else {
            self.showError(message: "Email is required")
            return
        }
        guard passwordTextField.text?.count != 0 else {
            self.showError(message: "Password is required")
            return
        }
        print("Trying to signup")
        AuthManager.signup(email: emailTextField.text!, username: usernameTextField.text!, password: passwordTextField.text!) { result in
                switch result {
                case.failure(let error):
                    // TODO: Set Error Message
                    print("error happened")
                    print(error)
                    print("Description: \(error.errorDescription)")
                    self.showError(message: error.errorDescription)
                    return
                case .success:
                    DispatchQueue.main.async {
                        guard let onboardingVC = self.storyboard?.instantiateViewController(identifier: StoryboardId.SignupConfirmationViewController.rawValue) else {
                            return
                        }
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(controller: onboardingVC)
                    }
                    return
            }
        }
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

