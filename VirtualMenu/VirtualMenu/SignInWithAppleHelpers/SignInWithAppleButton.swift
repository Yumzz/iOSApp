//
//  SignInWithAppleButton.swift
//  SwiftUISignInWithApple
//
//  Created by Rohan Tyagi on 05/29/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import AuthenticationServices

final class SignInWithAppleButton: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<SignInWithAppleButton>) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton()
    }
    
    func updateUIView(_ uiView: SignInWithAppleButton.UIViewType, context: UIViewRepresentableContext<SignInWithAppleButton>) {
    }
}
