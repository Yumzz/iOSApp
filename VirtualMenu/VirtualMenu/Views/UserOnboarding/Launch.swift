//
//  Launch.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/26/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct Launch: View {
    var shortcut = true
    @State var loggedIn = false
    @EnvironmentObject var user: UserStore
    
    
    var body: some View {               
        VStack{
            VStack{
                Text("Yumzz")
                    .font(.custom("Montserrat-Bold", size: 48))
                    .foregroundColor(Color.white)
                    .bold()
                
                Spacer()
                    .frame(height: (UIScreen.main.bounds.height/2.5))
            }
            
        }
        .background(Color(UIColor().colorFromHex("#F88379", 1)))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Launch_Previews: PreviewProvider {
    static var previews: some View {
        Launch()
    }
}
