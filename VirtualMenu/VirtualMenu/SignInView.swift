//
//  SignInView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 5/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//
import SwiftUI
import AuthenticationServices


struct SignInView: View {
    
    @EnvironmentObject var signInWithAppleManager: SignInWithAppleManager
    
    @Environment(\.window) var window: UIWindow?
    @State private var signInWithAppleDelegates: SignInWithAppleDelegates! = nil
    
    @State private var isAlertPresented = false
    @State private var errDescription = ""

    var body: some View {
        NavigationView{
            
            VStack{
        
                VStack {
                    Logo()
                    Spacer()
                }
                VStack {
                    
                    //sign in button
                    SignInWithAppleButton()
                        .frame(width: 280, height: 60)
                        .padding()
                        .onTapGesture {
                            self.showAppleLogin()
                    }
                    Spacer()
                        
                }
                
                
            
            }
        }.alert(isPresented: $isAlertPresented){
            Alert(title: Text("Error"), message: Text(errDescription), dismissButton:
                .default(Text("OK"), action: {
                    self.signInWithAppleManager.isUserAuthenticated = .signedOut
                }))
        }
            

        
    }
    
    private func showAppleLogin(){
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        performSignIn(using: [request])
    }
    
    private func performExistingAccountSetupFlows(){
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        
        performSignIn(using: requests)
    }
    
    private func performSignIn(using requests: [ASAuthorizationRequest]){
        
        
        signInWithAppleDelegates = SignInWithAppleDelegates(window: window, onSignedIn: {
            (result) in
            switch result {
            case .success(let userId):
                UserDefaults.standard.set(userId, forKey: self.signInWithAppleManager.userIdentifierKey)
                self.signInWithAppleManager.isUserAuthenticated = .signedIn
            case .failure(let err):
                self.errDescription = err.localizedDescription
                self.isAlertPresented = true

                
            }
        })
        
        
        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = signInWithAppleDelegates
        controller.presentationContextProvider = signInWithAppleDelegates
        
        controller.performRequests()
    }
}
