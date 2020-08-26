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
    
    var socialLogin = SocialLogin()
    
    @ObservedObject var AuthenticationVM = AuthenticationViewModel()
    
    @EnvironmentObject var user: UserStore
    
    @State var loginSelection: Int? = nil
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var alert: Alert {
        Alert(title: Text(alertTitle), message: Text(alertMsg), dismissButton: .default(Text("OK")))
    }
    
    @ViewBuilder
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
    //            if user.showOnboarding {
                    VStack{
                        Text("Yumzz")
                        .font(.custom("Montserrat-SemiBold", size: 48))
                        .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
                        .bold()
                        .padding(.leading, 0)
                    }
                    
                    Text("Login to your account")
                    .font(.custom("Montserrat-SemiBold", size: 20))
                    .foregroundColor(Color(UIColor().colorFromHex("#707070", 1)))
                    .bold()
                    
                    CustomTextField(strLabel: "Email", strField: $email, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)
                    
                    CustomPasswordField(strLabel: "Password", password: $password)
                    
                    Button(action: {
                        
                        Auth.auth().signIn(withEmail: self.email, password: self.password){ result, error in
                            
                            if(error != nil){
                                print(error!)
                                self.alertMsg = "Your email or password is incorrect"
                                self.alertTitle = "Sign in error"
                                self.showAlert.toggle()
                            }
                            else{
                                self.loggedIn.toggle()
                                self.user.isLogged = true
                                UserDefaults.standard.set(true, forKey: "isLogged")
                                self.user.showOnboarding = false
                                UserDefaults.standard.set(true, forKey: "showOnboarding")
                                
                                self.AuthenticationVM.updateProfile()
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
                            
                        }
                        
                        Text("OR")
                               
                        
                        VStack{
                            Divider()
                                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                                .frame(width: (UIScreen.main.bounds.width/2.3), height: 10, alignment: .trailing)
                            

                        }
                        
                    }
                    
                    HStack{
                        Button(action: {
                            self.socialLogin.attemptLoginGoogle()
                        }){
                            SocialMediaButton(imgName: "continue_with_google")
                            .frame(width: 100, height: 50)
                        }

                        Button(action: {
                            print("apple")
                        }){
                            SocialMediaButton(imgName: "continue_with_apple")
                            .frame(width: 100, height: 50)
                        }

                        Button(action: {
                            self.logginFb()
                        }){
                            SocialMediaButton(imgName: "continue_with_facebook")
                            .frame(width: 100, height: 50)
                        }
                    }
                
                VStack(spacing: 20){
                    Button(action: {
                            self.user.showOnboarding = false
                    }){
                        GuestButton(strLabel: "Sign in as a Guest")
                    }
                        
                    Button(action: {
                    }, label: {
                        NavigationLink(destination: SignUpView()) {
                            Text("New User? Create an account")
                            .foregroundColor(.black)
                            .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .bold, design: .default))
                        }
                        
                    })
                }
            }
                
//            }

//            }else{
//                AppView()
//            }
        }.onAppear(perform: {
//            if let token = AccessToken.current,
//                !token.isExpired {
//                 User is logged in, do work such as go to next view controller.
//                self.user.showOnboarding = false
//            }
//            self.user.showOnboarding = true
        })
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert, content: { self.alert })
    }
    
    func logginFb() {
        socialLogin.attemptLoginFb(completion: { result, error in
            if(error == nil){
                self.user.isLogged = true
                self.user.showOnboarding = false
            }else{
                //create alert saying no account associated with this FB profile. Please use sign up page
                //make case for the error that comes when above happens
            }
        })
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
            
            fbLoginManager.logIn(permissions: ["email"], from: UIApplication.shared.windows.last?.rootViewController) { (result, error) -> Void in
                print("RESULT: '\(result)' ")
                let authen = AuthenticationViewModel()

                if error != nil {
                    print("error")
                    return
                }else if(result!.isCancelled){
                    print("result cancelled")
                    return
                }
                
                if(!result!.isCancelled){
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    
                    Auth.auth().signIn(with: credential) { (authResult, error) in
                        //authresult = Promise of UserCredential
                        print("signing in")
                        if(authResult != nil){
                            print("authorized")
                            print(authResult?.additionalUserInfo?.profile)
                            let userInfo = authResult?.additionalUserInfo?.profile
                            if let userInfo = userInfo as? [String:Any],
                                                       let email: String = userInfo["email"] as? String,
                                                       let name: String = userInfo["name"] as? String,
                                                       let picture = userInfo["picture"] as? [String: Any],
                                                       let data = picture["data"] as? [String: Any],
                                let url = data["url"] as? String {
                                    userProfile.fullName = name
                                    userProfile.emailAddress = email
                                    userProfile.profilePhotoURL = url
                                    print(userProfile.emailAddress)
                                    print(userProfile.fullName)
                                    dispatch.enter()
                                    authen.fetchUserID(name: userProfile.fullName, email: userProfile.emailAddress, dispatch: dispatch)
                                    dispatch.notify(queue: .main) {
                                        dispatch.enter()
                                        userProfile.getProfilePhoto(dispatch: dispatch)
                                        dispatch.notify(queue: .main){
                                            completion(result, error)
                                            return
                                        }
                                    }
                            }
                            print(authResult?.additionalUserInfo?.profile)
//                            print(Auth.auth().currentUser?.value(forKey: "displayName"))
//                            userProfile.emailAddress = Auth.auth().currentUser?.email! as! String
//                            userProfile.fullName = Auth.auth().currentUser?.displayName! as! String
                            print(userProfile.emailAddress)
                            print(userProfile.fullName)
                            dispatch.enter()
                            authen.fetchUserID(name: userProfile.fullName, email: userProfile.emailAddress, dispatch: dispatch)
                            dispatch.notify(queue: .main) {
                                dispatch.enter()
                                userProfile.getProfilePhoto(dispatch: dispatch)
                                dispatch.notify(queue: .main){
                                    completion(result, error)
                                    return
                                }
                            }
                        }
                        else{
                            //no account exists with this FB profile -> alert saying "please go to sign up"
                            print("no account exists")
                            print(error.debugDescription)
                            completion(result, error)
                            return
                        }
                    }
                }
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loggedin: .constant(false))
    }
}
