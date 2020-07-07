//
//  InitialScreen.swift
//  
//
//  Created by Rohan Tyagi on 6/24/20.
//

import SwiftUI

struct InitialScreen: View {
    
    @State private var isShowingLoginSheet = false
    @State private var isShowingSignUpSheet = false
    
        
    var body: some View {
        
        NavigationView{
            
            GeometryReader { geometry in
            ZStack {
                Image("initial_screen_back")
                    .resizable()
                    .overlay(Color(UIColor().colorFromHex("#F88379", 0.5)))
                    .aspectRatio(geometry.size, contentMode: .fill)
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
                    Button(action: { self.isShowingSignUpSheet.toggle()})
                    {
                        Text("SIGN UP")
                            .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                    }
                    .cornerRadius(10)
                    .padding().frame(width: UIScreen.main.bounds.width/1.5, height: 40)
                    .background(Color(UIColor().colorFromHex("#000000", 1)))
                    .sheet(isPresented: self.$isShowingSignUpSheet) { SignUpView() }
                    
                    Spacer().frame(height: 30)
                    
                    Button(action: { self.isShowingLoginSheet.toggle()})
                    {
                        Text("LOGIN")
                            .foregroundColor(Color(UIColor().colorFromHex("#000000", 1)))
                    }
                    .cornerRadius(10)
                    .padding().frame(width: UIScreen.main.bounds.width/1.5, height: 40)
                    .background(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                    .sheet(isPresented: self.$isShowingLoginSheet) { LoginView() }
                    
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
