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

var user: UserProfile = UserProfile(userId: "", fullName: "", emailAddress: "", profilePicture: "", profPhoto: nil)

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
    @State var showGoogle = false
    @State var showFB = false

    
    @State var loginSelection: Int? = nil
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var alert: Alert {
        Alert(title: Text(""), message: Text(alertMsg), dismissButton: .default(Text("OK")))
    }
    
    @ViewBuilder
    var body: some View {
            
                       VStack {
                            
                            VStack {
                                Spacer(minLength: (UIScreen.main.bounds.width * 15.0) / 414.0)
                                
                //                Logo + Name
                                
                                Spacer(minLength: (UIScreen.main.bounds.width * 15) / 414)
                                
                                VStack {
                                    
                //                    Logo()
                                    
                                    VStack(spacing: 0) {
                                        
                                        Text("Email")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                            .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
                                            
                                        
                                        TextField("", text: $email)
                                            .frame(height: (UIScreen.main.bounds.width * 40) / 414, alignment: .center)
                                            .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                            .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                                            .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .regular, design: .default))
                                            .imageScale(.small)
                                            .keyboardType(.emailAddress)
                                            .autocapitalization(UITextAutocapitalizationType.none)
                                        
                                        Divider().background(Color(UIColor().colorFromHex("#F88379", 1)))
                                        .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                        .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                                        
                                    }
                //                    seperator()
                                }
                                
                                Spacer(minLength: (UIScreen.main.bounds.width * 15) / 414)
                                
                                VStack {
                                    
                                    VStack(spacing: 0) {
                                        
                                        Text("Password")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                            .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
                                            
                                            
                                        
                                        SecureField("", text: $password)
                                            .frame(height: (UIScreen.main.bounds.width * 40) / 414, alignment: .center)
                                            .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                            .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                                            .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .regular, design: .default))
                                            .imageScale(.small)
                                            .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
                                        
                                        Divider().background(Color(UIColor().colorFromHex("#F88379", 1)))
                                        .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                        .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                                    }
                //                    seperator()
                                    
                                }
                                
                                Spacer(minLength: (UIScreen.main.bounds.width * 15) / 414)
                                
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
                //                        .sheet(isPresented: self.$showForgotPassword) {
                //                            ForgotPasswordView()
                //                        }
                                        
                                    }.padding(.trailing, (UIScreen.main.bounds.width * 10) / 414)
                                }
                                
                                VStack {
                                    Spacer()
                                        .frame(height: 10)
                                    Button(action: {
                                        if  self.isValidInputs() {
                                            Auth.auth().signIn(withEmail: self.email, password: self.password){
                                                (result, error) in
                                                if(error == nil){
                                                    self.updateProfile()
                                                }
                                                self.loggedin.toggle()
                                            }
                                        }
                                    }, label: {
            //                                AppView()
                                                Text("LOGIN")
                                                    .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                                            .navigationBarTitle("")
                                            .navigationBarHidden(true)
                                    })
                                    .cornerRadius(10)
                                    .padding().frame(width: UIScreen.main.bounds.width/1.5, height: 40)
                                    .background(Color(UIColor().colorFromHex("#000000", 1)))
                                    .frame(width: 100)
                                    .sheet(isPresented: self.$loggedin) {
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
                                        self.showGoogle.toggle()
                                        SocialLogin().attemptLoginGoogle()
                                    }){
                                        HStack{
                                            Image("continue_with_google")
                                                .renderingMode(.original)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 40, height: 40)
                                            Text("CONTINUE WITH GOOGLE")
                                            .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
                                        }
                                    }
                                    CustomButton(action: {
                                        self.showFB.toggle()
                                        SocialLogin().attemptLoginFb(completion: { result, error in
                                        })

                                    }){
                                        HStack{
                                            Image("continue_with_facebook")
                                                .renderingMode(.original)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 40, height: 40)
                                            Text("CONTINUE WITH FACEBOOK")
                                            .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
                                        }
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
                                }
                                
                //
                //                    Spacer(minLength: (UIScreen.main.bounds.width * 20) / 414)
                //                }
                            }
                        }
                        .alert(isPresented: $showAlert, content: { self.alert })
            //            .background(Image("initial_screen_back")
            //                        .resizable()
            //                        .overlay(Color(UIColor().colorFromHex("#FFFFFF", 0.8)))
            //                        .edgesIgnoringSafeArea(.all))
    }
    
    
    func updateProfile() {
            let storage = Storage.storage()
            let imagesRef = storage.reference().child("profilephotos/\(Auth.auth().currentUser!.uid)")
            
            print(imagesRef.storage)
            print(imagesRef.bucket)
            print(imagesRef.name)
        
            Utils().getUserProfileImgURL(userId: Auth.auth().currentUser!.uid, completionHandler: { (res) in
                user.profilePhotoURL = res
            })
                
            user.userId = Auth.auth().currentUser!.uid
            Database.database().reference().child("users").child(user.userId).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                user.fullName = value?["username"] as? String ?? ""
            })
//            user.fullName = Auth.auth().currentUser!.displayName!
             user.emailAddress = Auth.auth().currentUser!.email!
            
            //finishes after return is given as it is a little slow
             DispatchQueue.main.async {
                imagesRef.getData(maxSize: 2 * 2048 * 2048) { data, error in
                if let error = error {
                  // Uh-oh, an error occurred!
                    user.profilePhoto = UIImage(imageLiteralResourceName: "profile_photo_edit")
                    print(error.localizedDescription)
                } else {
                  // Data for "profilephotos/\(uid).jpg" is returned
                    print("data: \(data)")
                    user.profilePhoto = UIImage(data: data!)!
                    }
                }
            }
    //        DispatchQueue.main.async {
    //        }
        print(user.profilePhotoURL)
        print(user.emailAddress)
        print(user.fullName)
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loggedin: .constant(false))
    }
}
