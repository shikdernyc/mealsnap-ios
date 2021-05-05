//
//  AuthManager.swift
//  MealSnap
//
//  Created by Asif Shikder on 3/23/21.
//

import Foundation
import Amplify
import AWSPluginsCore

typealias AuthOperationListender = (Result<Bool, AuthError>) -> Void

enum RestoreUserError : Error {
    case NotLoggedIn
}

enum  AuthManagerError : Error {
    case UnAuthenticated
}

typealias RestoreUserCompletion = (Result<Bool, Error>) -> Void

struct AuthManager {
    static func login(username: String, password: String, completion: @escaping(AuthOperationListender)) {
        Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            case .success:
                self.notifyAuthStateChange()
                completion(.success(true))
            case .failure(let error):
                // TODO: Custom and Selective Error Handling
                completion(.failure(error))
            }
        }
    }
    
    static func CurrentUser() throws -> UserSummary{
        let user = Amplify.Auth.getCurrentUser()
        guard user != nil else {
            throw AuthManagerError.UnAuthenticated
        }
        return UserSummary(userId: user!.userId, userName: user!.username)
    }
    
    static func restoreSavedUser(completion: @escaping(RestoreUserCompletion)) {
        Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                if(session.isSignedIn){
                    self.notifyAuthStateChange()
                    completion(.success(true))
                }
                else{
                    completion(.failure(RestoreUserError.NotLoggedIn))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func signup(email: String, username: String, password: String, completion: @escaping(AuthOperationListender)){
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        Amplify.Auth.signUp(username: username, password: password, options: options) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func logout(listener: @escaping(AuthOperationListender)) {
        Amplify.Auth.signOut(){result in
            switch result {
            case .success:
                notifyAuthStateChange()
                listener(.success(true))
            case .failure(let err):
                listener(.failure(err))
            }
        }
        self.notifyAuthStateChange()
    }
    
    static func isAuthenticated() -> Bool {
        return Amplify.Auth.getCurrentUser() != nil
    }
}

protocol AuthStateChangeHandler : AnyObject {
    func onAuthStateChange(isAuthenticated: Bool) -> Void
}

extension AuthManager {
    private static var authChangeObservers = [ObjectIdentifier : AuthStateChangeHandler]()
    
    private static func notifyAuthStateChange(with newState: Bool = AuthManager.isAuthenticated()) {
        for (_, observer) in AuthManager.authChangeObservers {
            observer.onAuthStateChange(isAuthenticated: newState)
        }
    }
    
    static func onAuthStateChange(run handler: AuthStateChangeHandler){
        AuthManager.authChangeObservers[ObjectIdentifier(handler)] = handler
    }
    
    static func removeAuthStateChangeHandler(handler: AuthStateChangeHandler){
        AuthManager.authChangeObservers.removeValue(forKey: ObjectIdentifier(handler))
    }
}

extension AuthManager {
    static func RetrieveJWTToken(completionHandler: @escaping (Result<String, Error>) -> Void) -> Void {
        Amplify.Auth.fetchAuthSession { result in
            do {
                let session = try result.get()

                // Get cognito user pool token
                if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
                    let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                    completionHandler(.success(tokens.idToken))
                }

            } catch let error {
                completionHandler(.failure(error))
                print("Fetch auth session failed with error - \(error)")
            }
        }
    }
}
