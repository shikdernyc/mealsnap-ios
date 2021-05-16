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
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    func showError(message: String) -> Void {
        AlertComponent.showError(on: self, message: message)
    }
    
    @IBAction func handlePressSignup() {
        print("Handling signup")
        guard firstNameTextField.text?.count != 0 else {
            self.showError(message: "First Name is required")
            return
        }
        guard lastNameTextField.text?.count != 0 else {
            self.showError(message: "Last Name is required")
            return
        }
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
        AuthService.signup(
            firstName: firstNameTextField.text!,
            lastName: lastNameTextField.text!,
            email: emailTextField.text!,
            username: usernameTextField.text!,
            password: passwordTextField.text!
        ) { result in
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
                    guard let confirmationVC = self.storyboard?.instantiateViewController(identifier: StoryboardId.SignupConfirmationViewController.rawValue) else {
                        return
                    }
                    self.navigationController?.pushViewController(confirmationVC, animated: true)
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

