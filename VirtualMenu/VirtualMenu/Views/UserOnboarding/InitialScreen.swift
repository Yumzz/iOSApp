//
//  InitialScreen.swift
//  
//
//  Created by Rohan Tyagi on 6/24/20
//

import SwiftUI

struct InitialScreen: View {
    var shortcut = true
    @State var loggedIn = false
    @EnvironmentObject var navigator: Navigator
    
    
    var body: some View {
        
        ZStack {
            if navigator.isOnboardingShowing {
                NavigationView {
                    
                    ZStack {
                        Image("initial_screen_back")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .overlay(Color(UIColor().colorFromHex("#F88379", 0.5)))
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack{
                            VStack{
                                Text("Yumzz")
                                    .font(.custom("Montserrat-Bold", size: 48))
                                    .foregroundColor(Color.white)
                                    .bold()
                                
                                Spacer()
                                    .frame(height: (UIScreen.main.bounds.height/2.5))
                            }
                            
                            VStack{
                                Button(action: {
                                }, label: {
                                    NavigationLink(destination: SignUpView()) {
                                        BlackButton(strLabel: "SIGN UP")
                                    }
                                })
                                
                                Spacer().frame(height: 30)
                                
                                Button(action: {
                                }){
                                    NavigationLink(destination: LoginView(loggedin: self.$loggedIn)) {
                                        WhiteButton(strLabel: "LOGIN")
                                    }
                                }
                                
                                Spacer().frame(height: 30)
                                
                                Button(action: {
                                    withAnimation {
                                        self.navigator.isOnboardingShowing = false
                                    }
                                        
                                }){
                                    WhiteButton(strLabel: "Continue as a guest")
                                }
                                
                            }
                        }
                    }
                }
            } else {
                AppView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct InitialScreen_Previews: PreviewProvider {
    static var previews: some View {
        InitialScreen()
    }
}
