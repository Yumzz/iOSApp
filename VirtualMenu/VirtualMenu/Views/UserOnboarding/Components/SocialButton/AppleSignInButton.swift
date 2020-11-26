//
//  AppleSignInButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct AppleSignInButton: View {
        
    var body: some View {
        Group {
            ZStack() {
                SignInWithApple()
                    .frame(width: 80, height: 30)
//                    .cornerRadius(60)
                    .background(Color(UIColor(white: 1, alpha: 0)))
            }
            .padding()
        }
        .cornerRadius(60)
        .background((Color.white))
        .shadow(radius: 4)
//        .shadow(radius: 10)
    }
}
