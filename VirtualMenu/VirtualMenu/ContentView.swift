//
//  ContentView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 5/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import AuthenticationServices
import Firebase
//initial view
//Right now: View with Logo and says let's get started -> sign in

//Will be: walkthrough screens -> sign in view
struct ContentView: View {
    @State var loggedIn = false
    
    var body: some View {
        ZStack {
            let defaults = UserDefaults.standard
            let loggedIn = defaults.bool(forKey: "loggedIn")
            //if Auth.auth().currentUser != nil {
            if loggedIn {
                HomeScreenView()
//                DishAdminFetchView()
//                LoginView(loggedin: $loggedIn)
            } else {
               //User Not logged in
//                DishAdminView()
                OnboardingInfo()
//                DishAdminFetchView()
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
        
        VStack(spacing: 30){
            Image("logo")
                .padding(.bottom, 20)
                .frame(width: 40, height: 40, alignment: .center)
            Text("The Virtual Menu")
                .frame(alignment: .center)
        }
        
    }
    
}

struct AppleIdButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton()
    }
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
}

struct CustomButton <V: View> : View {
    
    let action: () -> Void
    let content: V
    
    init(action: @escaping () -> Void, @ViewBuilder content: () -> V){
        self.action = action
        self.content = content()
        
    }
    
    var body: some View{
        
        Button(action: action){
            content
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(
                    Image("ar").resizable().renderingMode(.original))
            
        }
        
        
    }
    
    
}
