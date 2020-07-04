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
            
            VStack{
                
                VStack{
                    
                    Logo()

                    Spacer()
                        .frame(height: (UIScreen.main.bounds.height/2.5))
                }
                      
                VStack{
                    CustomButton(action: { self.isShowingSignUpSheet.toggle()})
                    {
                        Text("SIGN UP")
                            .foregroundColor(.green)
                    }
                    .frame(width: 100)
                    .sheet(isPresented: self.$isShowingSignUpSheet) { SignUpView() }
                    
                    CustomButton(action: { self.isShowingLoginSheet.toggle()})
                    {
                        Text("LOGIN")
                            .foregroundColor(.green)
                    }
                    .frame(width: 100)
                    .sheet(isPresented: self.$isShowingLoginSheet) { LoginView() }
                    
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
