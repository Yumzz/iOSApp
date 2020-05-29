//
//  SignInWithAppleDelegates.swift
//  SwiftUISignInWithApple
//
//  Created by Rohan Tyagi on 05/29/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import UIKit
import AuthenticationServices


class SignInWithAppleDelegates: NSObject {
    private let signInSucceeded: (Result<String, Error>) -> ()
    private weak var window: UIWindow!
    
    init(window: UIWindow?, onSignedIn: @escaping (Result<String, Error>) -> ()) {
        self.window = window
        self.signInSucceeded = onSignedIn
    }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerDelegate {
    //This is where we must connect to backend and our own servers
    //When we create our own login, we need to have our own buttons and sign in
    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
        print("Registering new account with user: \(credential.user)")
        self.signInSucceeded(.success(credential.user))
    }
    
    private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
        print("Signing in with existing account with user: \(credential.user)")
        self.signInSucceeded(.success(credential.user))
    }
    
    private func signInWithUserAndPassword(credential: ASPasswordCredential) {
        print("Signing in using an existing iCloud Keychain credential with user: \(credential.user)")
        self.signInSucceeded(.success(credential.user))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
                registerNewAccount(credential: appleIdCredential)
            } else {
                signInWithExistingAccount(credential: appleIdCredential)
            }
            
            break
            
        case let passwordCredential as ASPasswordCredential:
            signInWithUserAndPassword(credential: passwordCredential)
            
            break
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.signInSucceeded(.failure(error))
    }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window
    }
}
