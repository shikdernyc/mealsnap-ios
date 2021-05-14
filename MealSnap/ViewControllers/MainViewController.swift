//
//  MainViewController.swift
//  MealSnap
//
//  Created by Asif Shikder on 3/24/21.
//

import UIKit

class MainViewController: UIViewController, AuthStateChangeHandler {
    override func viewDidLoad() {
        super.viewDidLoad()
        MealSnapAPI.CheckConnection(){result in
            switch(result) {
            case .success:
                print("Connected to MealSnap API")
                return
            case .failure:
                print("Unable to connect to MealSnap API")
                return
            }
        }
        AuthService.onAuthStateChange(run: self)
        self.fetchCurrentAuthSession()
    }
    
    func onAuthStateChange(isAuthenticated: Bool) {
        print("Onboarding Auth State: \(isAuthenticated)")
        if(isAuthenticated){
            self.navToAuthVC()
        }else{
            self.navToOnboardingVC()
        }
    }
    
    private func navToAuthVC() {
        DispatchQueue.main.async {
            guard let rootAuthController = self.storyboard?.instantiateViewController(identifier: StoryboardId.AuthTabNavigationController.rawValue) else {
                return
            }
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(controller: rootAuthController)
        }
    }
    
    private func navToOnboardingVC() {
        DispatchQueue.main.async {
            guard let onboardingVC = self.storyboard?.instantiateViewController(identifier: StoryboardId.OnboardingNavigationController.rawValue) else {
                return
            }
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(controller: onboardingVC)
        }
    }
    
    func fetchCurrentAuthSession() {
        AuthService.restoreSavedUser() { result in
            switch result {
            case .success:
                print("Restored User")
            case .failure:
                self.navToOnboardingVC()
            }
        }
    }
}
