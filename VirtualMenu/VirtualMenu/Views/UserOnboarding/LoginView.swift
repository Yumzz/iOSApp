//
//  LoginView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 6/23/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import AuthenticationServices
import CryptoKit

struct LoginView: View {
    
    @EnvironmentObject var accountDetails: AccountDetails
    
    @State var email: String = ""
    @State var password: String = ""
    @State var alertMsg = ""
    @State var currentNonce: String? = ""
    
    @State private var showForgotPassword = false
    @State private var showSignup = false
    @State var showAlert = false
    @State var showDetails = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @Binding var loggedin: Bool
    @State var loggedIn = false
    @State var showGoogle = false
    @State var showFB = false
    
    @State var isNavigationBarHidden: Bool = true
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    


    @EnvironmentObject var user: UserStore
    @ObservedObject var loginVM = LoginViewModel()
    
    @Environment(\.window) var window: UIWindow?
    @State var delegate: SignInWithAppleDelegates! = nil

    
    @State var loginSelection: Int? = nil
    
    var alert: Alert {
        Alert(title: Text(alertTitle), message: Text(alertMsg), dismissButton: .default(Text("OK")))
    }
    
    @ViewBuilder
    var body: some View {
        ZStack {
        if user.showOnboarding {
//        NavigationView{
            ZStack{
                Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
            VStack{
                VStack(spacing: 10){
                    Text("Login to your account")
                        .foregroundColor(ColorManager.textGray)
                        .font(.largeTitle).bold()
                        .font(.system(size: 36))
                        .padding(.leading, 40)
                        .padding(.trailing, 40)
                        .position(x: UIScreen.main.bounds.width/2.5, y: 20)
                        
                    CustomTextField(field: "Email", strLabel: "jonnyives@apple.com", strField: $email, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)

                    CustomPasswordField(field: "Password", strLabel: "••••••••••", password: $password)
                        
    //                VStack {
                        HStack {
                            NavigationLink(destination: ForgotPasswordView()){
                                    Text("Forgot Password?")
                                        .foregroundColor(Color(UIColor().colorFromHex("#B4B4B4", 1)))
                                        .font(.system(size: 12, weight: .bold, design: .default))
                                    
                                }
                        }
                        .padding(.trailing, (UIScreen.main.bounds.width/1.8))
    //                }
                    
                    
                        Button(action: {
                            let dispatch = DispatchGroup()
                            dispatch.enter()
                            //do valid inputs and make move current user != nil if to account profile view
                            self.loginVM.loginUser(email: self.email, password: self.password, disp: dispatch)
                            dispatch.notify(queue: .main){
                                if(self.loginVM.alertMessage != ""){
                                    self.alertMsg = self.loginVM.alertMessage
                                    self.alertTitle = self.loginVM.alertTitle
                                    self.showAlert.toggle()
                                }else{
                                    if(Auth.auth().currentUser != nil){
                                        self.user.isLogged = true
                                        UserDefaults.standard.set(true, forKey: "isLogged")
                                        print(self.user.showOnboarding)
                                        self.user.showOnboarding = false
                                        self.isNavigationBarHidden = true
                                        print(self.user.showOnboarding)
                                        UserDefaults.standard.set(false, forKey: "showOnboarding")
                                    }else{
                                        print(userProfile.emailAddress)
                                        self.alertMsg = "There is no such user"
                                        self.alertTitle = "No User"
                                        self.showAlert.toggle()
                                    }
                                }
                            }
                        }) {
                            OrangeButton(strLabel: "Login", width: 330, height: 48)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                        }
                }
                
                Spacer().frame(width: 0, height: 40)
                
                VStack(spacing: 10){
                    
                    AppleButton(width: 330, height: 48)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                        .onTapGesture {
                            self.showAppleLogin()
                        }
                    
                    FacebookButton(width: 330, height: 48)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                        .onTapGesture {
                            self.loginVM.logginFb()
                        }
                    
                    GoogleButton(width: 330, height: 48)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                        .onTapGesture {
                            self.loginVM.socialLogin.attemptLoginGoogle()
                        }
                        .shadow(radius: 5)
                }
                
                Spacer()
            }
            }.navigationBarTitle("")
            .navigationBarHidden(self.isNavigationBarHidden)
//            }
    }else{
            HomeScreenView()
                .onAppear(){
                    self.isNavigationBarHidden = true
                }
    }
        }
        .onAppear(perform: {
            self.email = ""
            self.password = ""
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "NoMoreOnboard"), object: nil, queue: .main) { (Notification) in
                self.user.showOnboarding = false
                self.user.isLogged = true
            }
        })
        .navigationBarTitle("")
        .navigationBarHidden(self.isNavigationBarHidden)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(mode: self.mode))
            .onAppear(){
                self.isNavigationBarHidden = false
            }
        .alert(isPresented: $showAlert, content: { self.alert })
    }
        private func performExistingAccountFlows(){
            let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                            ASAuthorizationPasswordProvider().createRequest()
            ]
            performSignIn(using: requests)
        }
        
        func showAppleLogin(){
            let nonce = self.loginVM.randomNonceString()
            currentNonce = nonce
            let request = ASAuthorizationAppleIDProvider()
            .createRequest()
            request.requestedScopes = [
                .fullName, .email
            ]
            performSignIn(using: [request])
            request.nonce = self.loginVM.sha256(nonce)

        }

        
        private func performSignIn(using requests: [ASAuthorizationRequest]){
            login = true
            signUp = false
            print("yes")
            delegate = SignInWithAppleDelegates(window: window, currentNonce: currentNonce!){ result in
                switch result {
                case .success(_):
                    //already created a new account or signed in
                    print("success")
    //                dispatch.leave()
                    let d = DispatchGroup()
                    d.enter()
                    self.loginVM.updateProfile(dispatch: d)
                    d.notify(queue: .main){
                        self.user.showOnboarding = false
                        self.user.isLogged = true
                        self.isNavigationBarHidden = true
                    }
                    
                case .failure(let error):
                    print("no succ")

                    //send alert
                    self.alertMsg = "\(error.localizedDescription)"
                    self.alertTitle = "Error!"
    //                dispatch.leave()
                }
            }
            let controller = ASAuthorizationController(authorizationRequests: requests)
            controller.delegate = delegate
            controller.presentationContextProvider = delegate
            controller.performRequests()
        }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loggedin: .constant(false))
    }
}
