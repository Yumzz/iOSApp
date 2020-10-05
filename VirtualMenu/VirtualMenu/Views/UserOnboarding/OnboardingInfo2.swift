//
//  Onboarding-Info2.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/4/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase

struct OnboardingInfo2: View {
    @State var loggedIn = false
    
    @EnvironmentObject var user: UserStore
    @ObservedObject var loginVM = LoginViewModel()

    var body: some View {
        ZStack{
            NavigationView{
                ZStack{
                    Color(UIColor().colorFromHex("#F3F1EE", 1)).edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer().frame(width: UIScreen.main.bounds.width, height: 0)
                    
                    VStack(spacing: 20){
                        Text("Welcome to Yumzz")
                            .foregroundColor(Color(UIColor().colorFromHex("#3A3A3A", 1)))
                            .font(.largeTitle).bold()
                            .font(.system(size: 36))
                            .padding(.leading, 40)
                            .padding(.trailing, 40)
                        
                        Image("Onboarding-Info2")
//                            .position(x: UIScreen.main.bounds.width/2, y: 110)
                    }
                    
                //picture
                    Spacer().frame(height: 60)
                //sign up button
                //login button
                //sign in as guest button
                    VStack(spacing: 20){
                        NavigationLink(destination: SignUpView()){
                            OrangeButton(strLabel: "Sign Up", width: 330, height: 48)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                        }
                        
                        NavigationLink(destination: LoginView(loggedin: $loggedIn)){
                            InvertedOrangeButton(strLabel: "Login", width: 330, height: 48)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                                .shadow(radius: 5)
                        }
                        
                        NavigationLink(destination: AppView()){
                            InvertedOrangeButton(strLabel: "Use app as a guest", width: 330, height: 48)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                                .shadow(radius: 5)
                                .onTapGesture {
                                    self.user.showOnboarding = false
                                    let firebaseAuth = Auth.auth()
                                    do {
                                        defer{
                                            self.loginVM.ridProfile()
                                            Auth.auth().signInAnonymously() { (authResult, error) in
                                              // ...
                                                print("anonymous")
                                                if(error != nil){
                                                    print(error.debugDescription)
                                                }
                                                else{
                                                    print(authResult?.additionalUserInfo)
                                                }
                                            }
                                        }
                                          try firebaseAuth.signOut()
            
                                        } catch let signOutError as NSError {
                                          print ("Error signing out: %@", signOutError)
                                        }
                                    self.user.isLogged = false
                                }
                        }
                    }
                    Spacer()
                    
                }
                }
            }
            
//            Spacer().fame(height: 80)

        }.navigationTitle("")
        .navigationBarHidden(true)
        .background(Color(UIColor().colorFromHex("#F3F1EE", 1)))
    }
}

struct OnboardingInfo2_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingInfo2()
    }
}

