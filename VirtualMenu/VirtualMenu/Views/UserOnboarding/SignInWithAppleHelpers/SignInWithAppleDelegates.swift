//
//  SignInWithAppleDelegates.swift
//  SwiftUISignInWithApple
//
//  Created by Alex Nagy on 03/11/2019.
//  Copyright © 2019 Alex Nagy. All rights reserved.
//
import UIKit
import AuthenticationServices
import Firebase

class SignInWithAppleDelegates: NSObject {
    private let signInSucceeded: (Result<String, Error>) -> ()
    private weak var window: UIWindow!
    fileprivate var currentNonce: String?
    
    init(window: UIWindow?, currentNonce: String, onSignedIn: @escaping (Result<String, Error>) -> ()) {
        self.window = window
        self.signInSucceeded = onSignedIn
        self.currentNonce = currentNonce
    }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerDelegate {
    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
        
        print("Registering new account with user: \(credential.user)")
        self.signInSucceeded(.success(credential.user))
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "NoMoreOnboard"), object: nil)
    }
    
    private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
        print("Signing in with existing account with user: \(credential.user)")
        self.signInSucceeded(.success(credential.user))
//        NotificationCenter.default.post(name: Notification.Name(rawValue: "NoMoreOnboard"), object: nil)
    }
    
    private func signInWithUserAndPassword(credential: ASPasswordCredential) {
        print("Signing in using an existing iCloud Keychain credential with user: \(credential.user)")
        self.signInSucceeded(.success(credential.user))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            guard let nonce = currentNonce else {
              fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIdCredential.identityToken else {
                   print("Unable to fetch identity token")
                   return
                 }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                   print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                   return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                    rawNonce: nonce)
            print("beforesignin")
            Auth.auth().signIn(with: credential) { (res, err) in
                if let err = err {
                    print(err.localizedDescription)
                }
                print("res")
                if(signUp){
                    print("sign")
                    if let email = appleIdCredential.email, let name = appleIdCredential.fullName {
                        UserDefaults.standard.set(email, forKey: "Email")
                        UserDefaults.standard.set(name, forKey: "Name")
                        print("register")
                    }
                    self.registerNewAccount(credential: appleIdCredential)
                    signUp = false
                }
                if(login) {
                    print("log")
                    self.signInWithExistingAccount(credential: appleIdCredential)
                    login = false
                }
            }

//            if(signUp){
//                print("sign")
//                if let email = appleIdCredential.email, let name = appleIdCredential.fullName {
//                    UserDefaults.standard.set(email, forKey: "Email")
//                    UserDefaults.standard.set(name, forKey: "Name")
//                    print("register")
//                }
//                registerNewAccount(credential: appleIdCredential)
//                signUp = false
//            }
//            if(login) {
//                print("log")
//                signInWithExistingAccount(credential: appleIdCredential)
//                login = false
//            }
            
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
