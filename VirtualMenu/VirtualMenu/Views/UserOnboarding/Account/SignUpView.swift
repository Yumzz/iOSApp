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
    @State var showBanner:Bool = true
    @State var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "Plant a Tree", detail: "For every person that signs up with email and password, we will plant a tree!")

    
    @State var createdAccount = false
    
    @EnvironmentObject var user: UserStore
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @Environment(\.window) var window: UIWindow?
    @State var delegate: SignInWithAppleDelegates! = nil
    
    @GestureState private var dragOffset = CGSize.zero
    
    var alert: Alert {
        Alert(title: Text(""), message: Text(alertMsg), dismissButton: .default(Text("OK")))
    }
    
    @ObservedObject var signUpVM = SignUpViewModel()
    
    var body: some View {
        ZStack {
            Color("DarkBack").edgesIgnoringSafeArea(.all)
            if user.showOnboarding {
                VStack(spacing: 10) {
//                    VStack{
                    Spacer().frame(width: UIScreen.main.bounds.width, height: 60)
                        Text("Create your account")
                            .foregroundColor(Color("WhiteTextGrey"))
                            .font(.largeTitle).bold()
                            .font(.system(size: 36))
//                            .padding(.leading, 40)
//                            .padding(.trailing, 20)
                            .padding(.vertical)
//                            .position(x: UIScreen.main.bounds.width/2, y: 0)
//                    Spacer()
                        
//                    }
//                    Spacer()
//                    Spacer().frame(width: UIScreen.main.bounds.width, height: 5)
                    
                    CustomTextField(field: "Name",strLabel: "Jonny Ives", strField: $name, uiTextAutoCapitalizationType: .words, uiKeyboardType: .default).foregroundColor(Color("Back"))
                    
                    CustomTextField(field: "Email",strLabel: "jonnyives@apple.com", strField: $email, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress).foregroundColor(Color("Back"))
                    
                    CustomPasswordField(field: "Password", strLabel: "••••••••••", password: $password).foregroundColor(Color("Back"))
                    
                    Button(action: {
                        let dispatch = DispatchGroup()
                        dispatch.enter()
                        google = false
                        facebook = false
                        print("sign up")
                        var message = ""
//                        if(!password.isValidPassword){
//                            message = "Error" + "|" + "Not valid email!"
//                            self.alertTitle = message.components(separatedBy: "|")[0]
//                            self.alertMessage = message.components(separatedBy: "|")[1]
//                            self.showAlert.toggle()
//                        }
//                        else{
                        message = self.signUpVM.signUpUser(email: self.email, name: self.name, password: self.password, dispatch: dispatch)
                        self.name = ""
                        self.email = ""
                        self.password = ""
                        self.alertTitle = message.components(separatedBy: "|")[0]
                        self.alertMessage = message.components(separatedBy: "|")[1]
                        self.showAlert.toggle()
                        dispatch.notify(queue: .main){
                            print("done")
                            
                            user.showOnboarding = false
                            
                        }

                        
                    })
                    {
                        NavigationLink(destination: HomeScreenView(), isActive: $createdAccount){
                            OrangeButton(strLabel: "Sign Up", width: 330, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                        }.disabled(!self.createdAccount)
                    }
                    
                    VStack(spacing: 10){
                        AppleButton(width: 330, height: 48)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                            .onTapGesture {
                                self.showAppleLogin()
                            }
                        
                        FacebookButton(width: 330, height: 48)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                            .onTapGesture {
                                let dispatch = DispatchGroup()
                                dispatch.enter()
                                self.signUpVM.signUpFb(dispatch: dispatch)
                                dispatch.notify(queue: .main){
                                    self.alertTitle = self.signUpVM.returnAlertTitle()
                                    self.alertMessage = self.signUpVM.returnAlertMessage()
                                    print("wow: \(self.signUpVM.alertTitle)")
                                    print("wow: \(self.signUpVM.alertMessage)")
                                    self.showAlert.toggle()
                                }
                            }
                        
                        GoogleButton(width: 330, height: 48)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                            .onTapGesture {
                                let dispatch = DispatchGroup()
                                dispatch.enter()
                                self.signUpVM.socialLogin.attemptSignUpGoogle(dis: dispatch)
                                dispatch.notify(queue: .main){
                                    self.alertMessage = "A confirmation email was sent to the email associated with the provided google account. Please click the link to sign in!"
                                    self.alertTitle = "Email Sent!"
                                    self.showAlert.toggle()
                                }
                            }
                    }
                    Spacer()
                }.banner(data: $bannerData, show: $showBanner)
                    .navigationBarItems(leading: BackButton(mode: self.mode))
            }else{
                HomeScreenView().navigationBarBackButtonHidden(self.user.isLogged)
                    .onAppear(){
                        self.user.isLogged = true
                    }
            }
        }
//        .background(Color(UIColor().colorFromHex("#F3F1EE", 1)))
        .keyboardAdaptive()
        .onAppear(perform: {
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "NoMoreOnboard"), object: nil, queue: .main) { (Notification) in
                self.user.showOnboarding = false
                self.user.isLogged = true
            }
        })
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: BackButton(mode: self.mode))
        .alert(isPresented: $showAlert) {
            Alert(title: Text("\(self.alertTitle)"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("Got it!")))
        }
//        .alert(isPresented: $showAlert, content: { self.alert })
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.translation.width > 100) {
                self.mode.wrappedValue.dismiss()
            }
        }))
        .edgesIgnoringSafeArea([.top, .bottom])
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

