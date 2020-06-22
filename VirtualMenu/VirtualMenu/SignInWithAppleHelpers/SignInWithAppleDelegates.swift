//
//  SignInWithAppleDelegates.swift
//  SwiftUISignInWithApple
//
//  Created by Rohan Tyagi on 05/29/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import UIKit
import AuthenticationServices
import CloudKit


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
                KeychainItem.currentUserIdentifier = appleIdCredential.user
                KeychainItem.currentUserFirstName = appleIdCredential.fullName?.givenName
                KeychainItem.currentUserLastName = appleIdCredential.email
                print("User Id - \(appleIdCredential.user)")
                print("User Name - \(appleIdCredential.fullName?.description ?? "N/A")")
                print("User Email - \(appleIdCredential.email ?? "N/A")")
                print("Real User Status - \(appleIdCredential.realUserStatus.rawValue)")
                registerNewAccount(credential: appleIdCredential)
                //keychain
            } else {
                KeychainItem.currentUserIdentifier = appleIdCredential.user
                KeychainItem.currentUserFirstName = appleIdCredential.fullName?.givenName
                KeychainItem.currentUserLastName = appleIdCredential.fullName?.familyName
                KeychainItem.currentUserEmail = appleIdCredential.email
                print("User Id - \(appleIdCredential.user)")
                print("User Name - \(appleIdCredential.fullName?.description ?? "N/A")")
                print("User Email - \(appleIdCredential.email ?? "N/A")")
                print("Real User Status - \(appleIdCredential.realUserStatus.rawValue)")
                signInWithExistingAccount(credential: appleIdCredential)
                //keychain
            }
            
            break
            
        case let passwordCredential as ASPasswordCredential:
            signInWithUserAndPassword(credential: passwordCredential)
            //keychain
            break
            
        default:
            let userID : String = KeychainItem.currentUserIdentifier!
            
            let query = CKQuery(recordType: "ARMUser", predicate: NSPredicate(value: true))
            let db = CKContainer.default().publicCloudDatabase
            var userExist = false
            db.perform(query, inZoneWith: nil) { (records, error) in
                for record in records! {
                    userExist = userExist || (record.value(forKey: "CloudIdentifier") as! String == userID)
                }
            }
            do {
                sleep(1)
            }
            
            if (!userExist) {
                // add such a user
                let ARMUserRecord = CKRecord(recordType: "ARMUser")
                ARMUserRecord.setValue(userID, forKey: "CloudIdentifier")
                ARMUserRecord.setValue(0, forKey: "Karma")
                ARMUserRecord.setValue([], forKey: "ModelUploaded")
                ARMUserRecord.setValue(nil, forKey: "ProfilePhoto")
                ARMUserRecord.setValue([], forKey: "Reviews")
                
                db.save(ARMUserRecord){ (record, error) -> Void in
                    DispatchQueue.main.sync {
                        self.processResponse(record: record, error: error)
                    }
                }
            }
            UserStruct.name = userID
            // 97 -124
        }
    }
    
    private func processResponse(record: CKRecord?, error: Error?) {
        var message = ""
        
        if let error = error {
            print(error)
            message = "We were not able to create a user."
            
        } else if record == nil {
            message = "We were not able to create a user."
        }
        
        print(message)
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
