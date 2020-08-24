//
//  LoginView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 6/23/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

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

struct LoginView: View {
    
    @EnvironmentObject var accountDetails: AccountDetails
    
    @State var email: String = ""
    @State var password: String = ""
    @State var alertMsg = ""
    
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
    
    @ObservedObject var AuthenticationVM = AuthenticationViewModel()

    @EnvironmentObject var navigator: Navigator

    
    @State var loginSelection: Int? = nil
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var alert: Alert {
        Alert(title: Text(""), message: Text(alertMsg), dismissButton: .default(Text("OK")))
    }
    
    @ViewBuilder
    var body: some View {
        
        VStack(spacing: 30) {
            CustomTextField(strLabel: "Email", strField: $email, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)
            
            CustomPasswordField(strLabel: "Password", password: $password)
            
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
            
            Button(action: {
                Auth.auth().signIn(withEmail: self.email, password: self.password){
                    (result, error) in
                    if(error == nil){
                        self.AuthenticationVM.updateProfile()
                    }
                    else{
                        self.alertMessage = "No user exists with those credentials"
                        self.alertTitle = "No user"
                        self.showAlert.toggle()
                    }
                    self.loggedIn.toggle()
                    self.navigator.isOnboardingShowing = false
                }
            }) {
                    BlackButton(strLabel: "LOGIN")
            }
            
            HStack{
                
                VStack{
                    Divider()
                        .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                        .frame(width: (UIScreen.main.bounds.width/2.3), height: 10, alignment: .leading)
                    
                }
                
                Text("OR")
                
                VStack{
                    Divider()
                        .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                        .frame(width: (UIScreen.main.bounds.width/2.3), height: 10, alignment: .trailing)
                }
                
            }
            
            Button(action: {
                SocialLogin().attemptLoginGoogle()
            }){
                BlackButton(strLabel: "Sign In with Google", imgName: "continue_with_google")
            }
            
            Button(action: {
                self.showFB.toggle()
                SocialLogin().attemptLoginFb(completion: { result, error  in
                    if(!result!.isCancelled){
                        self.navigator.isOnboardingShowing = false
                    }
                })
            }){
                BlackButton(strLabel: "Sign In with Facebook", imgName: "continue_with_facebook")
            }
            
            Button(action: {
                self.showSignup.toggle()
            }) {
                Text("New User? Create an account")
                    .foregroundColor(.black)
                    .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .bold, design: .default))
                
            }
            .sheet(isPresented: self.$showSignup) {
                SignUpView()
            }
        }.onAppear(perform: {
            if let token = AccessToken.current,
                !token.isExpired {
                // User is logged in, do work such as go to next view controller.
                self.navigator.isOnboardingShowing = false
            }
        })
        .navigationBarTitle("Sign In")
        .alert(isPresented: $showAlert, content: { self.alert })
    }
    
    
    struct SocialLogin: UIViewRepresentable {
        
        func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
            return UIView()
        }
        
        func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
        }
        
        func attemptLoginGoogle() {
            login = true
            signUp = false
            GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
            GIDSignIn.sharedInstance()?.signIn()
            
        }
        
        func attemptLoginFb(completion: @escaping (_ result: LoginManagerLoginResult?, _ error: Error?) -> Void) {
            var dispatch = DispatchGroup()
            let fbLoginManager: LoginManager = LoginManager()
            fbLoginManager.logOut()
            print("logged out")
            fbLoginManager.logIn(permissions: ["email", "name", "public_profile"], from: UIApplication.shared.windows.last?.rootViewController) { (result, error) -> Void in
                print("RESULT: '\(result)' ")
                let authen = AuthenticationViewModel()
                var navigator: Navigator

                if(!result!.isCancelled){
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)

                    Auth.auth().signIn(with: credential) { (authResult, error) in
                        //authresult = Promise of UserCredential
                        if(authResult != nil){
                            userProfile.emailAddress = Auth.auth().currentUser?.email! as! String
                            userProfile.fullName = Auth.auth().currentUser?.displayName! as! String
                            print(userProfile.emailAddress)
                            print(userProfile.fullName)
                            dispatch.enter()
                            authen.fetchUserID(name: userProfile.fullName, email: userProfile.emailAddress, dispatch: dispatch)
                            dispatch.notify(queue: .main) {
                                userProfile.getProfilePhoto()
//                                navigator.isOnboardingShowing = false
                                return
                            }
                        }
                    }
                }
                
                if error != nil {
                    print("error")
                }else if(result!.isCancelled){
                    print("result cancelled")
                }else{
                    print("success Get user information.")

                    let fbRequest = GraphRequest(graphPath:"me", parameters: ["fields":"email, name, picture"])
                    fbRequest.start { (connection, result, error) -> Void in

                    if error == nil {
                        print("User Info : \(result ?? "No result")")

                    } else {
                        print("Error Getting Info \(error ?? "error" as! Error)");

                        }
                    }
                }
                completion(result, error)
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loggedin: .constant(false))
    }
}
