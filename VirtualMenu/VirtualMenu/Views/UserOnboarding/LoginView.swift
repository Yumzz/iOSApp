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
    


    @EnvironmentObject var user: UserStore
    @ObservedObject var loginVM = LoginViewModel()
    
    @Environment(\.window) var window: UIWindow?
    @State var delegate: SignInWithAppleDelegates! = nil

    
    @State var loginSelection: Int? = nil
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var alert: Alert {
        Alert(title: Text(alertTitle), message: Text(alertMsg), dismissButton: .default(Text("OK")))
    }
    
    @ViewBuilder
    var body: some View {
        ZStack {
        if user.showOnboarding {
        NavigationView{
            VStack(spacing: 20) {
                    VStack{
                        Text("Yumzz")
                        .font(.custom("Open Sans-SemiBold", size: 50))
                        .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
                        .bold()
                        .padding(.leading, 0)
                        
                    }
                    
                    Text("Login to your account")
                    .font(.custom("Open Sans-SemiBold", size: 20))
                    .foregroundColor(Color(UIColor().colorFromHex("#707070", 1)))
                    .bold()
                    .padding(.trailing, (UIScreen.main.bounds.width) / 3)
                    
                    
                    CustomTextField(strLabel: "Email", strField: $email, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)

                    CustomPasswordField(strLabel: "Password", password: $password)
                    
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
                        CoralButton(strLabel: "Sign in")
                    }
                
                
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            Spacer()
                                .frame(height: 5)
                            
                            Button(action: {
                                self.showForgotPassword = true
                            }) {
                                Text("Forgot Password?")
                                    .foregroundColor(.black)
                                    .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                                    .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .bold, design: .default))
                                
                            }
                            .sheet(isPresented: self.$showForgotPassword) {
                                ForgotPasswordView()
                                //dismiss once confirmation alert is sent
                            }
                            
                        }.padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                    }
                    
                    HStack{
                        
                        VStack{
                            Divider()
                                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                .frame(width: (UIScreen.main.bounds.width/2.3), height: 10, alignment: .leading)
                            .foregroundColor(Color(UIColor().colorFromHex("#C4C4C4", 1)))
                            
                        }
                        
                        Text("Or")
                            .foregroundColor(Color(UIColor().colorFromHex("#C4C4C4", 1)))
                               
                        
                        VStack{
                            Divider()
                                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                                .frame(width: (UIScreen.main.bounds.width/2.3), height: 10, alignment: .trailing)
                                .foregroundColor(Color(UIColor().colorFromHex("#C4C4C4", 1)))
                        }
                        
                    }
                    
                    HStack{
                        Button(action: {
                            self.loginVM.socialLogin.attemptLoginGoogle()
                        }){
                            SocialMediaButton(imgName: "continue_with_google")
                            .frame(width: 100, height: 50)
                        }

                        AppleSignInButton()
                        .frame(width: 100, height: 50)
                            .onTapGesture {
                                self.showAppleLogin()
                        }

                        Button(action: {
                            self.loginVM.logginFb()
                        }){
                            SocialMediaButton(imgName: "continue_with_facebook")
                            .frame(width: 100, height: 50)
                        }
                }
                
                VStack(spacing: 20){
                    Button(action: {
                        self.user.showOnboarding = false
                        let firebaseAuth = Auth.auth()
                        do {
                            defer{
                                self.loginVM.ridProfile()
                                Auth.auth().signInAnonymously() { (authResult, error) in
                                  // ...
                                    print("anonymous")
                                    if(error != nil){
                                        print(error.debugDescription)
                                    }
                                    else{
                                        print(authResult?.additionalUserInfo)
                                    }
                                }
                            }
                              try firebaseAuth.signOut()
                        
                            } catch let signOutError as NSError {
                              print ("Error signing out: %@", signOutError)
                            }
                        self.user.isLogged = false
                    }){
                        GuestButton(strLabel: "Sign in as a Guest")
                    }
                        
                    Button(action: {
                    }, label: {
                        NavigationLink(destination: SignUpView()) {
                            HStack{
                                    Text("Don't have an account?")
                                    .foregroundColor(Color(UIColor().colorFromHex("#C4C4C4", 1)))
                                    .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .bold, design: .default))
                                
                                    Text("Sign Up")
                                    .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
                                    .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .bold, design: .default))
                                }
                            }
                        
                    })
                }
            }
            }
        }else{
                AppView()
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
        .navigationBarHidden(true)
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
                    self.user.showOnboarding = false
                    self.user.isLogged = true
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
