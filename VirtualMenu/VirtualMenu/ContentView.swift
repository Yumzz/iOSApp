//
//  ContentView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 5/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import AuthenticationServices

//initial view
//Right now: View with Logo and says let's get started -> sign in

//Will be: walkthrough screens -> sign in view
struct ContentView: View {
    @EnvironmentObject var signInWithAppleManager: SignInWithAppleManager
    
    
     var body: some View {
        NavigationView{
           ZStack {
            if signInWithAppleManager.isUserAuthenticated == .undefined {
                //should be taken to walkthrough screens
                SignInView()
            } else if signInWithAppleManager.isUserAuthenticated == .signedOut{
                //take to sign in view
                SignInView()
            }
            else if signInWithAppleManager.isUserAuthenticated == .signedIn{
                //take into restaurant selection view
                SignInView()
            }
           }
        }
           
       }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: Context) -> UIViewController {
        
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}

struct Logo: View {

    
    
    
    var body: some View {
        
        Image("logo")
           .padding(.bottom, 20)
            .frame(width: 40, height: 40, alignment: .center)

        
    }

}

struct AppleIdButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
            ASAuthorizationAppleIDButton()
    }
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
}
