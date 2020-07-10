//
//  CreateAccount.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/7/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit


struct CreateAccount: View {

        @EnvironmentObject var accountDetails: AccountDetails
        //@EnvironmentObject var settings: UserSettings
        @State var name: String = ""
        @State var email: String = ""
        @State var password = ""
        @State var confirmPassword = ""

        @State var checkBox = "UncheckBox"
        @State var checkBoxState = false
        @State var alertMsg = ""
        @State var selection: Int = 1
        @State var integers: [String] = ["0", "1", "2", "3", "4", "5"]

        @State var date = Date()

        @State var showReferralCodeView = false

        @State var showImagePicker: Bool = false
        @State var showCamera: Bool = false
        @State var image: Image? = nil

        @State var showAlert = false
        @State var showActionSheet: Bool = false

        @State var signupSelection: Int? = nil
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

        @State private var birthDate = Date()



        var alert: Alert {
            Alert(title: Text(""), message: Text(alertMsg), dismissButton: .default(Text("OK")))
        }

        var body: some View {

//            UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
            NavigationView {


            ScrollView {

                VStack {

                    RoundedImage()
                
                    VStack {
                        HStack {
                            Image("ic_email")
                                .padding(.leading, 20)

                            TextField("Email", text: $email)
                                .frame(height: 40, alignment: .center)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .imageScale(.small)
                        }
                        seperator()
                    }

                    VStack {

                        HStack {

                            Image("ic_user")
                                .padding(.leading, 20)

                            TextField("Name", text: $name)
                                .frame(height: 40, alignment: .center)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .imageScale(.small)

                        }
                        seperator()
                    }

                    VStack {

                        HStack {

                            Image("ic_password")
                                .padding(.leading, 20)

                            SecureField("Password", text: $password)
                                .frame(height: 40, alignment: .center)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .imageScale(.small)

                        }
                        seperator()
                    }

                    VStack {

                        HStack {

                            Image("ic_password")
                                .padding(.leading, 20)

                            SecureField("Confirm Password", text: $confirmPassword)
                                .frame(height: 40, alignment: .center)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .imageScale(.small)

                        }
                        seperator()
                    }

                    Spacer(minLength: (UIScreen.main.bounds.width * 15) / 414)


                    VStack {

    //                    VStack {
    //
    //                        NavigationLink(destination: LoginView(), tag: 1, selection: $signupSelection) {
    //                            Button(action: {
    //                                if  self.isValidInputs() {
    //                                    print("Signup tapped")
    //                                    self.signupSelection = 1
    //                                }
    //
    //                            }) {
    //                                HStack {
    //                                    buttonWithBackground(btnText: "SUBMIT")
    //                                }
    //                            }
    //
    //                        }
    //                    }

                        //Spacer(minLength: 30)
                        HStack {
                            Button(action: {
                                     print("button pressed")
                                self.checkBoxState.toggle()
                                     if(self.checkBoxState) {
                                         self.checkBox = "checkBox"
                                     }
                                     else {
                                         self.checkBox = "UncheckBox"
                                     }

                                   }) {
                                       Image(checkBox)
                            
                            }
                            Text("By signing up you accept our terms and conditions")
                            .foregroundColor(.blue)
                            .underline()
                            .font(.custom("Open Sans Bold", size: 12))
                            .onTapGesture {
                                let url = URL.init(string: "https://flave.app/terms-and-conditions")
                                guard let flaveURL = url, UIApplication.shared.canOpenURL(flaveURL) else { return }
                                UIApplication.shared.open(flaveURL)
                                //self.checkBox = "checkBox"
                                //self.checkBoxState = true
                            }
                            
                        }
                        
                        Spacer(minLength: 30)
                        Button(action: {
                            
                            if(self.checkBoxState) {
                                if self.isValidInputs() {

                                    //self.presentationMode.wrappedValue.dismiss()




                                    self.accountDetails.name = self.name
                                    self.accountDetails.email = self.email
                                    self.accountDetails.password = self.password
                                    self.accountDetails.loggedIn = true
                                    UserDefaults.standard.set(true, forKey: "LoggedIn")
                                    self.showReferralCodeView = true
                                    UserDefaults.standard.synchronize()
                                    
                                    
                                }
                            }
                            else {
                                self.alertMsg = "You must accept the Terms and Conditions before continuing"
                                self.showAlert.toggle()
                            }
                        }) {

                            buttonWithBackground(btnText: "Create Account")
                        }
                        .padding(.bottom, (UIScreen.main.bounds.width * 30) / 414)
                        .alert(isPresented: $showAlert, content: { self.alert })
                        
//                        NavigationLink(destination: ReferralCodeView()) {
//
//                        }

                        .sheet(isPresented: $showReferralCodeView) {
                            ReferralCodeView().environmentObject(self.accountDetails)
                        }
                    }

                }

            }
            }
        }
        
    
        fileprivate func isValidInputs() -> Bool {

            if self.email == "" {
                self.alertMsg = "Email can't be blank."
                self.showAlert.toggle()
                return false
            } else if self.name == "" {
                self.alertMsg = "Name can't be blank."
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
            }
            else if !(self.password.isValidPassword) {
                self.alertMsg = "Please enter valid password"
                self.showAlert.toggle()
                return false
            }
            else if self.confirmPassword == "" {
                self.alertMsg = "Confirm password can't be blank."
                self.showAlert.toggle()
                return false
            } else if self.password != self.confirmPassword {
                self.alertMsg = "Password and confirm password does not match."
                self.showAlert.toggle()
                return false
            }

            return true
        }
}

struct CreateAccount_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccount()
    }
}
