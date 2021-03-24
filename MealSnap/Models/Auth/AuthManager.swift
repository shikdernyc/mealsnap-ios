//
//  AuthManager.swift
//  MealSnap
//
//  Created by Asif Shikder on 3/23/21.
//

import Foundation

struct AuthUserDetail {
    let userId: String
    let userName: String
}

struct AuthManager {
    private static var isLoggedIn = false
    
    private func setIsLoggedIn(to value: Bool){
        AuthManager.isLoggedIn = value
    }
    
    static func login(email: String, password: String) {
        AuthManager.isLoggedIn = true
        self.notifyAuthStateChange()
    }
    
    static func signup(email: String, username: String, password: String){
        AuthManager.isLoggedIn = true
        self.notifyAuthStateChange()
    }
    
    static func logout() {
        AuthManager.isLoggedIn = false
        self.notifyAuthStateChange()
    }
    
    static func isAuthenticated() -> Bool {
        return AuthManager.isLoggedIn
    }
}

protocol AuthStateChangeHandler : class {
    func onAuthStateChange(isAuthenticated: Bool) -> Void
}

extension AuthManager {
    private static var authChangeObservers = [ObjectIdentifier : AuthStateChangeHandler]()
    
    private static func notifyAuthStateChange() {
        for (_, observer) in AuthManager.authChangeObservers {
            observer.onAuthStateChange(isAuthenticated: self.isLoggedIn)
        }
    }
    
    static func onAuthStateChange(run handler: AuthStateChangeHandler){
        AuthManager.authChangeObservers[ObjectIdentifier(handler)] = handler
    }
    
    static func removeAuthStateChangeHandler(handler: AuthStateChangeHandler){
        AuthManager.authChangeObservers.removeValue(forKey: ObjectIdentifier(handler))
    }
}
