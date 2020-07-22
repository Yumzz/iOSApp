//
//  ForgotPassword.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/20/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase

struct ForgotPasswordView: View {
    
    @State var email: String = ""
    @State var showAlert = false
    @State var alertMsg = ""
    @State var showingAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""

    var alert: Alert {
        Alert(title: Text(""), message: Text(alertMsg), dismissButton: .default(Text("OK")))
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                VStack {
//                    Logo
//                        .frame(width: 50, height: 50, alignment: .center)
//                        .edgesIgnoringSafeArea(.top)
                    Spacer(minLength: 80)
                    Text("Forgot your password?")
                        .font(.custom("Futura Bold", size: 24))
                    Text("No problem, we'll send you a reset email link")
                        .font(.custom("Open Sans", size: 12))
                        .padding()
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
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
                                .keyboardType(.emailAddress)
                                .autocapitalization(UITextAutocapitalizationType.none)
                        }
                      
                    }
                    
                    Spacer(minLength: 20)
                    
                    Button(action: {
                        if self.isValidInputs() {
                            Auth.auth().sendPasswordReset(withEmail: self.email) { (error) in
                                if(error != nil){
                                    print(error?.localizedDescription)
                                    return
                                }
                                else{
                                    self.alertMessage = "Email has been sent. Go through provided link"
                                    self.showingAlert = true
                                    
                                }
                            }
                        }
                    }) {
                        Text("Send Reset Link")
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("\(self.alertTitle)"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }.alert(isPresented: $showAlert, content: { self.alert })
    }
    
    func isValidInputs() -> Bool {
        
        if self.email == "" {
            self.alertMsg = "Email can't be blank."
            self.showAlert.toggle()
            return false
            
        } else if !self.email.isValidEmail {
            self.alertMsg = "Email is not valid."
            self.showAlert.toggle()
            return false
        }
        
        return true
    }
}

struct ModalView: View {
    
  var body: some View {
    Group {
      Text("Modal view")
      
    }
  }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
        
    }
}

