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
    
    var body: some View {
            
            VStack {
                
                VStack {
                    Spacer(minLength: (UIScreen.main.bounds.width * 15.0) / 414.0)
                    
//                    Logo + Name
                                        
                    VStack {
                        
                        Spacer(minLength: (UIScreen.main.bounds.width * 15) / 414)

                        Logo()
                                                
                        VStack(spacing: 0) {
                            
                            Text("Name")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                            
                            TextField("", text: $name)
                                .frame(height: (UIScreen.main.bounds.width * 40) / 414, alignment: .center)
                                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                                .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .regular, design: .default))
                                .imageScale(.small)
                                .autocapitalization(UITextAutocapitalizationType.words)
                            
                            Divider()
                            .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                            .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                        }
    //                    seperator()
                    }
                    
                    Spacer(minLength: (UIScreen.main.bounds.width * 15) / 414)
                    
                    VStack {
                        
                        VStack(spacing: 0) {
                            
                            Text("Email")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                
                            
                            TextField("", text: $email)
                                .frame(height: (UIScreen.main.bounds.width * 40) / 414, alignment: .center)
                                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                                .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .regular, design: .default))
                                .imageScale(.small)
                            .keyboardType(.emailAddress)
                            .autocapitalization(UITextAutocapitalizationType.none)
                            
                            Divider()
                            .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                            .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                        }
    //                    seperator()
                        
                    }
                    
                    Spacer(minLength: (UIScreen.main.bounds.width * 15) / 414)
                    
                    VStack{
                        
                        VStack(spacing: 0) {
                            Text("Password")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                
                                
                            
                            SecureField("", text: $password)
                                .frame(height: (UIScreen.main.bounds.width * 40) / 414, alignment: .center)
                                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                                .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .regular, design: .default))
                                .imageScale(.small)
                            
                            Divider()
                            .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                            .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                        }
                        //                    seperator()
                    }
                    
                    
                    VStack {
                        Spacer()
                            .frame(height: 10)
                        CustomButton(action: {
                            if self.isValidInputs() {
                                Auth.auth().createUser(withEmail: self.email, password: self.password){
                                    (result, error) in
                                    if (error != nil){
                                        self.alertMsg = "Error creating user"
                                        self.showAlert.toggle()
                                    }
                                    else{
                                        let db = Firestore.firestore()
                                        db.collection("User").addDocument(data: ["email": self.email, "password": self.password, "username": self.name, "id": result!.user.uid]) {(error) in
                                            
                                            if error != nil {
                                                self.alertMsg = "Error saving user info"
                                                self.showAlert.toggle()
                                            }
                                            
                                        }
                                        
                                    }
                                    self.createdAccount.toggle()
                                }
                                
                            }
                        })
                        {
                            Text("SIGN UP")
                                .foregroundColor(.green)
                        }
                        .frame(width: 100)
                        .sheet(isPresented: self.$createdAccount) {
                            AppView()
                        }


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
                    
                    VStack(spacing: 10){
                        Spacer()
                            .frame(height: 10)
                        CustomButton(action: {
//                            self.showAlert.toggle()
                            SocialLogin().attemptLoginGoogle()
                        }){
                            HStack{
                                Image("continue_with_google")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                Text("CONTINUE WITH GOOGLE")
                                .foregroundColor(.green)
                            }
                        }
                        CustomButton(action: {
//                            self.showAlert.toggle()
                            SocialLogin().attemptLoginFb(completion: { result, error in
                                print(result)
                            })
                        }){
                            HStack{
                                Image("continue_with_facebook")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                Text("CONTINUE WITH FACEBOOK")
                                .foregroundColor(.green)
                            }
                        }
                        
                        Spacer()
                    }
                }
                
        }
    }
    
    fileprivate func isValidInputs() -> Bool {
        if self.email == "" {
            self.alertMsg = "Email can't be blank."
            self.showAlert.toggle()
            return false
        } else if !self.email.isValidEmail {
            self.alertMsg = "Email is not valid."
            self.showAlert.toggle()
            return false
        } else if self.password == "" {
            self.alertMsg = "Password can't be blank."
            self.showAlert.toggle()
            return false
        } else if !(self.password.isValidPassword) {
            self.alertMsg = "Please enter valid password"
            self.showAlert.toggle()
            return false
        }
        return true
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
        SignUpView()
    }
}
