//
//  SignUpView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 6/24/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices
import CryptoKit

var signUp = false
var login = false
var facebook = false
var google = false
var credential: AuthCredential? = nil

struct SignUpView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var name: String = ""
    
    @State var alertMsg = ""
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @State var showAlert = false
    @State var showDetails = false
    @State var currentNonce: String? = ""

    
    @State var createdAccount = false
    
    @EnvironmentObject var user: UserStore
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @Environment(\.window) var window: UIWindow?
    @State var delegate: SignInWithAppleDelegates! = nil
    

    
    var alert: Alert {
        Alert(title: Text(""), message: Text(alertMsg), dismissButton: .default(Text("OK")))
    }
    
    @ObservedObject var signUpVM = SignUpViewModel()
    
    var body: some View {
        ZStack {
            if user.showOnboarding {
                VStack(spacing: 30) {
                    Text("Yumzz")
                    .font(.custom("Montserrat-SemiBold", size: 48))
                    .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
                    .bold()
                    
                    Text("Create your account")
                    .font(.custom("Montserrat-SemiBold", size: 20))
                    .foregroundColor(Color(UIColor().colorFromHex("#707070", 1)))
                    .bold()
                    .padding(.trailing, (UIScreen.main.bounds.width) / 3)

                    
                    CustomTextField(strLabel: "Name", strField: $name, uiTextAutoCapitalizationType: .words, uiKeyboardType: .default)
                    
                    CustomTextField(strLabel: "Email", strField: $email, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)
                    
                    CustomPasswordField(strLabel: "Password", password: $password)
                    
                    Button(action: {
                        let dispatch = DispatchGroup()
                        dispatch.enter()
                        self.signUpVM.signUpUser(email: self.email, name: self.name, password: self.password, dispatch: dispatch)
                        self.alertMessage = self.signUpVM.alertMessage
                        self.alertTitle = self.signUpVM.alertTitle
                        self.showAlert.toggle()
                    })
                    {
                        NavigationLink(destination: AppView(), isActive: $createdAccount){
                            CoralButton(strLabel: "Sign Up")
                        }.disabled(!self.createdAccount)
                    }
                    
                    
                    HStack {
                        
                        VStack {
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
                            self.signUpVM.socialLogin.attemptSignUpGoogle()
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
                            self.signUpVM.signUpFb()
                        }){
                            SocialMediaButton(imgName: "continue_with_facebook")
                            .frame(width: 100, height: 50)
                        }.alert(isPresented: $showAlert) {
                            Alert(title: Text("\(self.alertTitle)"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK")))
                        }
                    }
                    Spacer()
                }
            }else{
                AppView()
            }
        }.onAppear(perform: {
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "NoMoreOnboard"), object: nil, queue: .main) { (Notification) in
                self.user.showOnboarding = false
                self.user.isLogged = true
            }
        })
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: PinkBackButton(mode: self.mode))
    }
    
    private func performExistingAccountFlows(){
            let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                            ASAuthorizationPasswordProvider().createRequest()
            ]
            performSignUp(using: requests)
        }
        
        func showAppleLogin(){
            let nonce = self.signUpVM.randomNonceString()
            currentNonce = nonce
            let request = ASAuthorizationAppleIDProvider()
            .createRequest()
            request.requestedScopes = [
                .fullName, .email
            ]
            performSignUp(using: [request])
            request.nonce = self.signUpVM.sha256(nonce)
        }
        
        func performSignUp(using requests: [ASAuthorizationRequest]){
            login = false
            signUp = true
            print("here")
            delegate = SignInWithAppleDelegates(window: window, currentNonce: currentNonce!){ result in
                switch result {
                case .success(_):
                    //already created a new account or signed in
    //                self.alertMessage = "You have successfully logged in through Apple"
    //                self.alertTitle = "Success!"
    //                self.showAlert.toggle()
                    self.user.showOnboarding = false
                    self.user.isLogged = true
                case .failure(let error):
                    //send alert
                    self.alertMessage = "\(error.localizedDescription)"
                    self.alertTitle = "Error!"
                }
            }
            let controller = ASAuthorizationController(authorizationRequests: requests)
            controller.delegate = delegate
            controller.presentationContextProvider = delegate
            controller.performRequests()
        }

}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView()
        }
    }
}
