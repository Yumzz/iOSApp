//
//  FacebookLoginButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/24/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import FBSDKLoginKit

struct FacebookLoginButton: FBLoginButton {
    
    var body: some View {
        
        var strLabel: String
        var imgName: String?
        
        var body: some View {
            Group {
                HStack(spacing: 10) {
                    
                    if (imageExists(named: imgName)){
                        
                        Image(imgName!)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }
                    
                    Text(strLabel)
                               .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                                   
                }
                .padding()
                    
            .modifier(LeadingTextModifier(imgExists: imageExists(named: imgName)))
               
            }
            .cornerRadius(10)
            .background(Color(UIColor().colorFromHex("#000000", 1)))
        }
        
        
    }
    
    
    
    
}
