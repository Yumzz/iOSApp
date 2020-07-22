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
    
    var body: some View {
        
        NavigationView{
                GeometryReader { geometry in
                    ZStack {
                        Image("initial_screen_back")
                            .resizable()
                            .aspectRatio(geometry.size, contentMode: .fill)
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
                                        Text("SIGN UP")
                                            .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                                            .padding().frame(width: UIScreen.main.bounds.width/1.5, height: 40)
                                    }
                                })
                                    .cornerRadius(10)
                                    .background(Color(UIColor().colorFromHex("#000000", 1)))
                                
                                Spacer().frame(height: 30)
                                
                                Button(action: {
                                }){
                                    NavigationLink(destination: LoginView(loggedin: self.$loggedIn)) {
                                        Text("LOGIN")
                                            .foregroundColor(Color(UIColor().colorFromHex("#000000", 1)))
                                        .padding().frame(width: UIScreen.main.bounds.width/1.5, height: 40)
                                    }
                                }
                                    .cornerRadius(10)
                                    .background(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                            }
                        }
                    }
                }
        }
    }
    }

struct InitialScreen_Previews: PreviewProvider {
    static var previews: some View {
        InitialScreen()
    }
}
