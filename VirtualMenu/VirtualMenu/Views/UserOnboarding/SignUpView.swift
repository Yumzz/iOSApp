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

struct SignUpView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var name: String = ""
    
    @State var alertMsg = ""
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @State var showAlert = false
    @State var showDetails = false
    
    @State var createdAccount = false
    
    @ObservedObject var AuthenticationVM = AuthenticationViewModel()
    
    var body: some View {
        
        VStack(spacing: 30) {
            
            CustomTextField(strLabel: "Name", strField: $name, uiTextAutoCapitalizationType: .words, uiKeyboardType: .default)
            
            CustomTextField(strLabel: "Email", strField: $email, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)
            
            CustomPasswordField(strLabel: "Password", password: $password)
            
            
            
            Button(action: {
                let val = self.AuthenticationVM.isValidInputs(email: self.email, password: self.password)
                if (val == "") {
                    let creation = self.AuthenticationVM.createUser(email: self.email, password: self.password, name: self.name)
                    if(creation) {
                        self.createdAccount.toggle()
                    }
                    else{
                        self.alertMsg = "Error creating user"
                        self.showAlert.toggle()
                    }
                }
                else{
                    self.alertMsg = val
                    self.showAlert.toggle()
                }
            })
            {
                NavigationLink(destination: AppView(), isActive: $createdAccount){
                    BlackButton(strLabel: "SIGN UP")
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
            
            Button(action: {
                // self.showAlert.toggle()
                SocialLogin().attemptLoginGoogle()
            }){
                BlackButton(strLabel: "Sign Up with Google", imgName: "continue_with_google")
            }
            Button(action: {
                // self.showAlert.toggle()
                SocialLogin().attemptLoginFb(completion: { result, error in
                })
            }){
                BlackButton(strLabel: "Sign Up with Facebook", imgName: "continue_with_facebook")
            }
        }
        .navigationBarTitle("Sign Up")
        .navigationBarBackButtonHidden(self.createdAccount)
        .navigationBarHidden(self.createdAccount)
    }
    
    
    struct SocialLogin: UIViewRepresentable {
        
        func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
            return UIView()
        }
        
        func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
        }
        
        func attemptLoginGoogle() {
            GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
            GIDSignIn.sharedInstance()?.signIn()
        }
        
        func attemptLoginFb(completion: @escaping (_ result: LoginManagerLoginResult?, _ error: Error?) -> Void) {
            let fbLoginManager: LoginManager = LoginManager()
            fbLoginManager.logOut()
            fbLoginManager.logIn(permissions: ["email", "name", "public_profile"], from: UIApplication.shared.windows.last?.rootViewController) { (result, error) -> Void in
                completion(result, error)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignUpView()
        }
    }
}
