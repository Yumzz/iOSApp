//
//  SignInWithAppleCoordinator.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import AuthenticationServices


final class SignInWithAppleCoordinator: NSObject {

    func getApppleRequest() {
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self as? ASAuthorizationControllerDelegate
        authController.performRequests()
    }
    
    private func setUserInfo(for userId: String, fullName: String?, email: String?) {
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userId) { credentialState, error in
            var authState: String?
            
            switch credentialState {
                case .authorized: authState = "authorized"
                case .revoked: authState = "revoked"
                case .notFound: authState = "notFound"
                case .transferred: authState = "transferred"
                @unknown default:
                        fatalError()
                }
            
//            let user = User(fullName: fullName ?? "not provided", email: email ?? "email", authState: authState ?? "unknown")
//            if let userEncoded = try? JSONEncoder().encode(user) {
//                UserDefaults.standard.set(userEncoded, forKey: "user")
//            }
        }
    }
}
