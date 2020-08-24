//
//  SwiftUIView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 18/08/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase

struct AccountProfileLoginView: View {
    
    @State var email = ""
    @State var password = ""
    
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    ///Keyboard focus
    @State var isFocused = false
    
    @State var showAlert = false
    
    @ObservedObject var AuthenticationVM = AuthenticationViewModel()
    
    @EnvironmentObject var user: UserStore
    
    var alert: Alert {
        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        
        VStack(spacing: 24) {
            
            Spacer()
            
            Text("Log in to synchronize your preferences and keep track of your past orders")
                .bold()
                .fixedSize(horizontal: false, vertical: true)
                .font(.subheadline)
            
            
            
            VStack {
                
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                        .frame(width: 44, height: 44)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.1), radius: 5, x: 0, y: 5)
                        .padding(.leading)
                    
                    TextField("Email".uppercased(), text: $email)
                        .font(.subheadline)
                        .padding(.leading)
                        .frame(height: 44)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .onTapGesture {
                            self.isFocused = true
                    }
                }
                
                Divider().padding(.leading, 80)
                
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                        .frame(width: 44, height: 44)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color(#colorLiteral(red: 0.1647058824, green: 0.1882352941, blue: 0.3882352941, alpha: 1)).opacity(0.1), radius: 5, x: 0, y: 5)
                        .padding(.leading)
                    
                    SecureField("Password".uppercased(), text: $password)
                        .font(.subheadline)
                        .padding(.leading)
                        .frame(height: 44)
                        .onTapGesture {
                            self.isFocused = true
                    }
                }
            }
            .frame(height: 136)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 20)
            
            Button(action: {
                
                Auth.auth().signIn(withEmail: self.email, password: self.password){ result, error in
                    
                    if error != nil {
                        print(error!)

                        self.alertMessage = "Your email or password is incorrect"
                        self.alertTitle = "Sign in error"
                        self.showAlert = true
                    }
                    else {
                        self.isFocused = false
                        self.hideKeyboard()
                        self.user.isLogged = true
                        UserDefaults.standard.set(true, forKey: "isLogged")
                        self.AuthenticationVM.updateProfile()
                    }
                }
            }) {
                Text("Log in")
                    .foregroundColor(.black)
                    .bold()
                    .frame(width: 120, height: 40)
                    .background(Color(#colorLiteral(red: 0, green: 0.7529411765, blue: 1, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0.7529411765, blue: 1, alpha: 1)).opacity(0.2), radius: 20, x: 0, y: 20)
            }
            
            
            Spacer()
            
            Text("Don't have an account?")
                .fixedSize(horizontal: false, vertical: true)
                .font(.subheadline)
            
            Button(action: {
            }, label: {
                NavigationLink(destination: SignUpView()) {
                    BlackButton(strLabel: "SIGN UP")
                }
            })
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .animation(.spring())
        .transition(.asymmetric(insertion: .slide, removal: .opacity))
        .onTapGesture {
            self.isFocused = false
            self.hideKeyboard()
        }
        .alert(isPresented: $showAlert, content: { self.alert })
        
    }
    
}

struct Loginv_Previews: PreviewProvider {
    static var previews: some View {
        AccountProfileLoginView()
    }
}
