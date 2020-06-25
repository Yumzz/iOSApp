//
//  LoginOrSignUpView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 6/24/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct LoginOrSignUpView: View {
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 10){
                
                //Logo

                Spacer()
                    .frame(height: 10)
                CustomButton(action: {
//                    navigate to sign up page

                }){
                    HStack{
                        Text("SIGN UP")
                        .foregroundColor(.green)
                    }
                }
                CustomButton(action: {
//                    navigate to login page

                }){
                    HStack{
                        Text("LOGIN")
                        .foregroundColor(.green)
                    }
                }
                
                Spacer()
                
                
                
            }
            
            
        }
        
        
        
    }
    
}


struct LoginOrSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        LoginOrSignUpView()
    }
}
