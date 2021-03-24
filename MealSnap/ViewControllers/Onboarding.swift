//
//  ViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 3/21/21.
//

import UIKit

class OnboardingViewController: UIViewController, AuthStateChangeHandler {
    func onAuthStateChange(isAuthenticated: Bool) {
        print("Onboarding Auth State: \(isAuthenticated)")
        if(isAuthenticated){
            self.navToAuthVC()
        }else{
            self.navToOnboardingVC()
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded onboarding vc")
        AuthManager.onAuthStateChange(run: self)
        // Do any additional setup after loading the view.
    }
    
    private func navToAuthVC() {
        guard let rootAuthController = storyboard?.instantiateViewController(identifier: StoryboardId.AuthTabNavigationController.rawValue) else {
            return
        }
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(controller: rootAuthController)
    }
    
    private func navToOnboardingVC() {
        guard let onboardingVC = storyboard?.instantiateViewController(identifier: StoryboardId.OnboardingNavigationController.rawValue) else {
            return
        }
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(controller: onboardingVC)
    }

}
