//
//  SwiftUIView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 18/08/2020.
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
    
struct AccountProfileLoginView: View {
    
    @State var email = ""
    @State var password = ""
    @State var currentNonce: String? = ""
    
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @Environment(\.window) var window: UIWindow?
    @State var delegate: SignInWithAppleDelegates! = nil
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    ///Keyboard focus
    @State var isFocused = false
    
    @State var showAlert = false
    
    @State private var showForgotPassword = false
    @State var alertMsg = ""
    
    @ObservedObject var loginVM = AccountProfileLoginViewModel()
    @State var isNavigationBarHidden: Bool = true
    
    @EnvironmentObject var user: UserStore
    
    var alert: Alert {
        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        ZStack{
            Color("DarkBack").edgesIgnoringSafeArea(.all)
            VStack{
                VStack(spacing: 10){
                    Text("Login and enjoy!")
                        .foregroundColor(Color("WhiteTextGrey"))
                        .font(.largeTitle).bold()
                        .font(.system(size: 36))
                        .padding(.leading, 40)
                        .padding(.trailing, 40)
                        .padding(.vertical)
//                    Spacer()
//                        .position(x: UIScreen.main.bounds.width/2.5, y: 10)
                        
                    CustomTextField(field: "Email", strLabel: "jonnyives@apple.com", strField: $email, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)

                    CustomPasswordField(field: "Password", strLabel: "••••••••••", password: $password)
                        
    //                VStack {
                        HStack {
                            NavigationLink(destination: ForgotPasswordView()){
                                    Text("Forgot Password?")
                                        .foregroundColor(Color("GreyWhite"))
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
                                print("wowo: \(self.loginVM.alertMessage)")
                                if(self.loginVM.alertMessage != ""){
                                    print("here")
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
                                        print("email: \(userProfile.emailAddress)")
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
            
            }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitle("")
        .navigationBarHidden(self.isNavigationBarHidden)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(mode: self.mode))
        .edgesIgnoringSafeArea([.top, .bottom])
        .onAppear(){
            self.isNavigationBarHidden = false
        }
        .onDisappear(){
            self.isNavigationBarHidden = true
        }
//        .animation(.spring())
//        .transition(.asymmetric(insertion: .slide, removal: .opacity))
//        .onTapGesture {
//            self.isFocused = false
//            self.hideKeyboard()
//        }
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


struct Loginv_Previews: PreviewProvider {
    static var previews: some View {
        AccountProfileLoginView()
    }
}
