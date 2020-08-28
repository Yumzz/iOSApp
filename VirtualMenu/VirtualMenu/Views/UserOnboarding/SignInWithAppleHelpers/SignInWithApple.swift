//
//  SignInWithApple.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import AuthenticationServices
import SwiftUI

final class SignInWithApple: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton()
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
    
    
}
